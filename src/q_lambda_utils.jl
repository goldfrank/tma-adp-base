#SARSA-lambda implementation of tracking problem
#Goldfrank 2021

######################################
### imports
######################################

using StaticArrays
using LinearAlgebra
using Random
using StatsBase
using SparseArrays
using DataStructures
using DataFrames
using CSV
using ArgParse
using Dates


function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--theta"
            help = ""
            default = "zeros"
        "--lambda"
            help = ""
            default = "0.9"
        "--alpha"
            help = ""
            default = "0.7"
        "--gamma"
            help = ""
            default = "0.9"
        "--epsilon"
            help = ""
            default = "0.1"
        "--collision"
            help = ""
            default = "-2"
        "--loss"
            help = ""
            default = "-2"
        "--N"
            help = ""
            default = "1000"
        "--trials"
            help = ""
            default = "1000"
        "--variance"
            help = ""
            default = "true"
        "--outfile"
            help = ""
            default = "sarsa_lambda.csv"
        "--determ"
            help = ""
            default = "false"
        "--results_dir"
            help = ""
            default = "../results/"
        "--start"
            help = ""
            default = "false"
        "--hist"
            help = ""
            default = "false"
    end

    return parse_args(s)
end

######################################
### generative model
######################################

#input is course in degrees and rng
#returns next course in degrees
function next_crs(crs,rng)
    if rand(rng) < .9
        return crs
    end
    crs = (crs + rand(rng,[-1,1])*30) % 360
    if crs < 0 crs += 360 end
    return crs
end

function next_crs_gen(crs,rng)
    if rand(rng) < .75
        return crs
    end
    crs = (crs + rand(rng,[-1,1])*30) % 360
    if crs < 0 crs += 360 end
    return crs
end

# state as tuple (x, y, crs, spd) of target (spd of o/s)
# returns next state as a function of current state and control(action)
function f(state, control, rng; input_crs="no", report_crs=false)
    TGT_SPD = 1
    r, θ, crs, spd = state
    spd = control[2]

    θ = θ % 360
    θ -= control[1]
    θ = θ % 360
    if θ < 0 θ += 360 end

    crs = crs % 360
    crs -= control[1]
    if crs < 0 crs += 360 end
    crs = crs % 360

    x = r*cos(π/180*θ)
    y = r*sin(π/180*θ)

    pos = [x + TGT_SPD*cos(π/180*crs) - spd, y +
        TGT_SPD*sin(π/180*crs)]


    old_crs = copy(crs)

    if input_crs == "no"
        crs = next_crs(crs,rng)
    else
        println("input crs")
        crs = (crs + input_crs) % 360
        if crs < 0 crs += 360 end
    end

    output_crs = (crs - old_crs) % 360
    if output_crs < 0 output_crs += 360 end

    r = sqrt(pos[1]^2 + pos[2]^2)
    θ = atan(pos[2],pos[1])*180/π
    if θ < 0 θ += 360 end

    if report_crs == false
        return (r, θ, crs, spd)::NTuple{4, Real}
    end
        return (r, θ, crs, spd, output_crs)::NTuple{5, Real}
end
#
ACTION_PENALTY = -.05

function f_gen(state, control, rng)
    TGT_SPD = 1
    r, θ, crs, spd = state
    spd = control[2]

    θ = θ % 360
    θ -= control[1]
    θ = θ % 360
    if θ < 0 θ += 360 end



    crs = crs % 360
    crs -= control[1]
    if crs < 0 crs += 360 end
    crs = crs % 360

    x = r*cos(π/180*θ)
    y = r*sin(π/180*θ)

    pos = [x + TGT_SPD*cos(π/180*crs) - spd, y +
        TGT_SPD*sin(π/180*crs)]
    crs = next_crs_gen(crs,rng)

    r = sqrt(pos[1]^2 + pos[2]^2)
    θ = atan(pos[2],pos[1])*180/π
    if θ < 0 θ += 360 end
    return (r, θ, crs, spd)::NTuple{4, Real}
end
# returns reward as a function of range
function r(s,u, action_penalty=ACTION_PENALTY)
    global COLLISION_REWARD, LOSS_REWARD
    if (2 < u < 5)
        action_penalty = 0
    end
    range = s[1]
    if range >= 150 return (COLLISION_REWARD + action_penalty) end  # reward to not lose track of contact
    if range <= 10 return (LOSS_REWARD + action_penalty) end  # collision avoidance
    return (0.1 + action_penalty)  # being in "sweet spot" maximizes reward
end

## defines action space and creates indexing function for actions
function actions()
    return ((-30,1), (-30, 2), (0, 1), (0, 2), (30, 1), (30, 2))
end

function action_index(action)
    return trunc(Int, 2*(action[1]/30+1) + action[2]) #clever, perhaps too clever
end

# returns vector rather than Tuple, for particle filter
function f2(x, u, rng; input_crs="no", report_crs=false)
    temp = [i for i in f(x, u, rng, input_crs=input_crs, report_crs=report_crs)]
    return temp
end

###########################################
## Implements Q-Lambda Learning Algorithm
###########################################
totals = [0.0]


function q_trial(θ=θ,trial_length=epochsize, λ=λ, α=α, γ=γ, ϵ=ϵ, N=N,
    burn_in_length=burn_in_length; start=false, hist=false)
    state_hist = []
    crs_hist = []
    e = sparse(zeros(length(grid),6))
    # println("start input: ", start)
    if start == false || start == "false"
        true_state = [rand(rng, 30:135), rand(rng,0:359), rand(rng,0:11)*30, 1]
    else
        true_state = copy(start)
    end
    push!(state_hist, copy(true_state))

    x = true_state
    #println("starting state: ", x)
    xp = x
    y = h(xp, rng)
    b = ParticleCollection([x[1:4] for i in 1:N])
    ξ = sparse(weighted_grid_2(b)/N)
    particle_collection = []
    starting_x = x

    action_hist = []
    state_hist = []
    crs_hist = []
    cur = 0
    last = 0
    uu = next_action([transpose(θ[:,j])*ξ for j in 1:size(θ)[2]], ϵ, rng)
    u = uu[1]
    collision_list = []
    loss_list = []
    zoof = 0
    cum_rew = 0
    collisions = 0
    loss = 0

    burn_in = true

    i = 0
    counter = false
    while i <= (trial_length + burn_in_length)
        #observe reward and new state
        rew = r(Tuple(xp),u)
        #b = update(pfilter, b, actions()[u], y)

        if hist == false || hist == "false"
            next_state = f2(x, actions()[u], rng, report_crs=true)
            # println("random next state: ", next_state)
        else
           next_state = f2(x, actions()[u], rng, input_crs=hist[i+1], report_crs=true)
            # println("next state: ", next_state)
        end
        push!(crs_hist, next_state[5])
        xp = next_state[1:4]

        # xp = f2(x, actions()[u], rng)

        y = h(xp, rng)
        b = update(pfilter, b, actions()[u], y)

        #update N(s,a) with state (t) weights
        e[:,u] += ξ
        old_u = u

        # choose next action
        uu = next_action([transpose(θ[:,j])*ξ for j in 1:size(θ)[2]], ϵ, rng)
        u = trunc(Int64,uu[1])
        #b = update(pfilter, b, actions()[u], y)

        #reset eligibility trace if action is random
        if uu[2] == 1
            e = sparse(zeros(length(grid),6))
            e[:,old_u] += ξ
        end

        #ξ is belief state at (t+1)
        ξ = sparse(weighted_grid_2(b)/N)

        #intermediate math
        cur = transpose(θ[:,uu[3]])*ξ #NOT the argmax!!
        δ = rew + γ * cur - last
        #last = transpose(θ[:,uu[1]])*ξ

        cum_rew += rew
        θ += α * δ * e
        e *= λ*γ

        last = transpose(θ[:,uu[1]])*ξ

        x = xp
        push!(state_hist, copy(x))

        if xp[1] < 10
            collisions = 1
        end

        i += 1
        # if (i == (trial_length + burn_in_length)) && xp[1] > 160 && counter == false
        #     i -= 10
        #     counter = true
        # end
    end

    if xp[1] > 160
        loss = 1
    end

    return (collisions, loss, θ, cum_rew, state_hist, crs_hist)
end

function q_trial_no_variance(θ=θ,trial_length=epochsize, λ=λ, α=α, γ=γ, ϵ=ϵ, N=N,
    burn_in_length=burn_in_length)
    e = sparse(zeros(length(grid),6))
    x = [rand(rng, 45:125), rand(rng,0:359), rand(rng,0:11)*30, 1];
    xp = x
    y = h(xp, rng)
    b = ParticleCollection([x[1:4] for i in 1:N])
    ξ = sparse(weighted_grid_simple(b)/N)
    particle_collection = []
    starting_x = x

    cur = 0
    last = 0
    uu = next_action([transpose(θ[:,j])*ξ for j in 1:size(θ)[2]], ϵ, rng)
    u = uu[1]
    collision_list = []
    loss_list = []
    zoof = 0
    cum_rew = 0
    collisions = 0
    loss = 0

    burn_in = true

    i = 0
    counter = false
    while i <= (trial_length + burn_in_length)
        #observe reward and new state
        rew = r(Tuple(xp),u)
        #b = update(pfilter, b, actions()[u], y)
        xp = f2(x, actions()[u], rng)

        y = h(xp, rng)
        b = update(pfilter, b, actions()[u], y)

        #update N(s,a) with state (t) weights
        e[:,u] += ξ
        old_u = u

        # choose next action
        uu = next_action([transpose(θ[:,j])*ξ for j in 1:size(θ)[2]], ϵ, rng)
        u = trunc(Int64,uu[1])
        #b = update(pfilter, b, actions()[u], y)

        #reset eligibility trace if action is random
        if uu[2] == 1
            e = sparse(zeros(length(grid),6))
            e[:,old_u] += ξ
        end

        #ξ is belief state at (t+1)
        ξ = sparse(weighted_grid_simple(b)/N)

        #intermediate math
        cur = transpose(θ[:,uu[3]])*ξ #NOT the argmax!!
        δ = rew + γ * cur - last
        #last = transpose(θ[:,uu[1]])*ξ

        cum_rew += rew
        θ += α * δ * e
        e *= λ*γ

        #should this be here??
        last = transpose(θ[:,uu[1]])*ξ

        x = xp

        if length(particles(b)) != N
            println("PARTICLE FILTER SIZE ERROR: ", length(particles(b)))
        end

        if xp[1] < 10
            zoof = 1
        end

        i += 1
        if (i == (trial_length + burn_in_length)) && xp[1] > 160 && counter == false
            i -= 10
            counter = true
        end
    end
    collisions += zoof
    if xp[1] > 160
        loss = 1
    end

    return (collisions, loss, θ, cum_rew)
end

# trial with random actions - for calibration only
function simple_trial(trial_length = epochsize; action = "rand")
    e = sparse(zeros(4,6))
    x = [rand(rng, 25:135), rand(rng,0:359), rand(rng,0:11)*30, 1];
    xp = x
    y = h(xp, rng)
    #b = ParticleCollection([x[1:4] for i in 1:N])
    #ξ = sparse(weighted_grid_2(b)/N)
    ξ = zeros(4)
    ξ[y+1] = 1
    #particle_collection = []
    #starting_x = x

    cur = 0
    last = 0
    if action == "rand"
        u = rand(rng, 1:6)
    else
        u = action
    end
    uu = [u, 1, u]
    collision_list = []
    loss_list = []
    zoof = 0
    cum_rew = 0
    collisions = 0
    loss = 0

    burn_in = true

    for i in 1:(trial_length + burn_in_length)
        #observe reward and new state
        rew = r(Tuple(xp),u)
        #b = update(pfilter, b, actions()[u], y)
        xp = f2(x, actions()[u], rng)

        y = h(xp, rng)



        u = rand(rng, 1:6)


        cum_rew += rew


        x = xp

        if xp[1] < 10
            zoof = 1
        end

    end
    collisions += zoof
    if xp[1] > 160
        loss = 1
    end

    return (collisions, loss, θ, false)
end

#
