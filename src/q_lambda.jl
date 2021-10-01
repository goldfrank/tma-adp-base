#SARSA-lambda implementation of tracking problem
#Goldfrank 2020

include("observations.jl")
include("polar_interpolation.jl")
include("q_lambda_utils.jl")

#time string for saving files
#now_string = string(now())
#global_start_time = string(now_string[1:4], "_", now_string[6:7], now_string[9:13], "_", now_string[15:16], "_", now_string[18:19])
global_start_time = string(now())


#seed random number generator (rng)
rng = MersenneTwister(2)

arguments = parse_commandline()

# set hyperparameters for trials
N = parse(Int64, arguments["N"])
model = ParticleFilterModel{Vector{Float64}}(f2, g)
pfilter = SIRParticleFilter(model, N);
α = parse(Float64, arguments["alpha"])
γ = parse(Float64, arguments["gamma"])
ϵ = parse(Float64, arguments["epsilon"])
variance_enabled = parse(Bool, arguments["variance"])
COLLISION_REWARD = parse(Float64, arguments["collision"])
LOSS_REWARD = parse(Float64, arguments["loss"])
EPSILON = ϵ
λ = parse(Float64, arguments["lambda"])
num_runs = parse(Int64, arguments["trials"])
start = arguments["start"]
hist = arguments["hist"]
testing = false
epochsize = 500
burn_in_length = 15
results_dir = arguments["results_dir"]
println("Writing results to: ", results_dir)

# input file for weights (theta)
infile = arguments["theta"]
print(infile)
# initialize weights to all 0, naive rewards, or previous results, based on command line arguments
if infile == "zeros"
    θ = zeros(length(grid),6);
elseif infile == "rewards"
    θ = [r(Tuple(ind2x(grid, j)),3) for j in 1:length(grid), i in 1:6];
else
    θ = convert(Matrix, CSV.read(infile, DataFrame))
end

#output header file
outfile = string(results_dir, global_start_time, "_weights.csv")
header_string = string("Q-Lambda Run: ", global_start_time)
header_string = string(header_string, "\n", "Lambda: ", λ)
header_string = string(header_string, "\n", "Gamma: ", γ)
header_string = string(header_string, "\n", "Alpha: ", α)
header_string = string(header_string, "\n", "N: ", N)
header_string = string(header_string, "\n", "Collision Reward: ", COLLISION_REWARD)
header_string = string(header_string, "\n", "Loss Reward: ", LOSS_REWARD)
header_string = string(header_string, "\n", "Variance: ", variance_enabled)

#write output header
header_filename = string(results_dir, global_start_time, "_header.txt")
open(header_filename, "w") do f
    write(f, header_string)
end


if start != "false"
    df_start = CSV.read(start, DataFrame)
    num_starts = ncol(df_start)
    start = df_start[!, 1]
    println("Running ", num_starts, " starting points.")
end
if hist != "false"
    println("using course change history")
    df_hist = CSV.read(hist, DataFrame)
    hist = df_hist[!,1]
end

println("start: ", start)

run_data = []

#cumulative collisions, losses, and number of trials
#total reward, and best average tracking
cum_coll = 0
cum_loss = 0
cum_outcome = 0
cum_trials = 0
total_reward = 0
best_average = 1

run_times = []
# q-lambda algorithm trials
for j in 1:num_starts
    global start
    if start != "false"
        start = df_start[!, j]
        println("Starting point ", j, " of ", num_starts, ": ", start)
    end
    for i in 1:num_runs
        run_start_time = now()
        global ϵ, EPSILON
        global variance_enabled
        global testing
        global cum_coll, cum_loss, cum_trials, run_data, cum_outcome
        global total_reward,  best_average
        global θ
        if variance_enabled
            result = q_trial()
            print(".")
        else
            result = q_trial_no_variance()
            println("histories inactive")
        end

        cum_coll += result[1]
        cum_loss += result[2]
        reward = result[4]
        state_hist = result[5]
        crs_hist = result[6]
        total_reward += reward
        cum_trials += 1

        if result[1] == 1 || result[2] == 1
            cum_outcome += 1
        end


        θ = result[3]
        push!(run_data,result[1:2])
        crs_out = [crs_hist]
        hist_out = state_hist

        if ((cum_outcome)/cum_trials < best_average) && cum_trials > 40
            best_average = (cum_outcome)/cum_trials
        end

        if cum_trials % 20 == 0 && false
            println("Current Score: ", (cum_coll+cum_loss)/cum_trials)
            println("θ Max: ", maximum(θ), " -- θ Min: ", minimum(θ))
        end

        push!(run_times, (now()-run_start_time).value)
        if i % 5 == 0
            weights_frame = DataFrame(θ)
            CSV.write(outfile, weights_frame)
            namefile = string(results_dir, global_start_time, "_data.csv")
            #CSV.write(namefile, DataFrame(run_data))
            updated_header = string(header_string, "\nAverage Runtime: ", mean(run_times))
            CSV.write(namefile, DataFrame(run_data))
            open(header_filename, "w") do f
                write(f, updated_header)
            end

        end

        if i % 20 == 0 || i == num_runs
            println("\n======================= MODEL STATUS ==========================")
            println("Round: ", i, " Best Average: ", round(best_average, sigdigits=4))
            println("Current Average: ", round(cum_outcome/cum_trials, sigdigits=4))
            println("Current Collison Rate: ", round((cum_coll)/cum_trials, sigdigits=4), " -- Col. Reward: ", COLLISION_REWARD)
            println("Current Loss Rate: ", round((cum_loss)/cum_trials, sigdigits=4), " -- Loss Reward: ", LOSS_REWARD)
            println("ϵ: ", ϵ, " α: ", α, " γ: ", γ, " λ: ", λ, " N: ", N)
            println("θ Max: ", maximum(θ), " -- θ Min: ", minimum(θ))
            println("===============================================================\n")

        end
        #CSV.write(string(results_dir, start, "_run_", i,"_hist.csv"), DataFrame([h for h in hist_out]))
        #CSV.write(string(results_dir, start, "_run_", i,"_crs.csv"), DataFrame([h for h in crs_out]))

        #used for variable epsilon-greedy strategy only
        #ϵ = max(min(.8, (cum_coll+cum_loss)/i),.005)
    end

    weights_frame = DataFrame(θ)
    CSV.write(outfile, weights_frame)
end
#
