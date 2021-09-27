#Goldfrank 2020 - Liedtka wrote a lot of the MCTS code

include("observations.jl")
include("mcts_utils.jl")

global_start_time = now()

#seed random number generator (rng)
rng = MersenneTwister(2)

arguments = parse_commandline()

# set hyperparameters for trials
N = parse(Int64, arguments["N"])
DEPTH = parse(Int64, arguments["depth"])
lambda = parse(Float64, arguments["lambda"])
num_runs = parse(Int64, arguments["trials"])
iterations = parse(Int64, arguments["iterations"])
COLLISION_REWARD = parse(Float64, arguments["collision"])
LOSS_REWARD = parse(Float64, arguments["loss"])
start = arguments["start"]
hist = arguments["hist"]
c = parse(Float64, arguments["c"])
results_dir = arguments["results_dir"]
println("Writing results to: ", results_dir)

#output header file
header_string = string("MCTS Run: ", global_start_time)
header_string = string(header_string, "\n", "Depth: ", DEPTH)
header_string = string(header_string, "\n", "N: ", N)
header_string = string(header_string, "\n", "Lambda: ", lambda)
header_string = string(header_string, "\n", "Iterations: ", iterations)
header_string = string(header_string, "\n", "Collision Reward: ", COLLISION_REWARD)
header_string = string(header_string, "\n", "Loss Reward: ", LOSS_REWARD)
header_string = string(header_string, "\n", "start: ", start)
header_string = string(header_string, "\n", "hist: ", hist)
header_string = string(header_string, "\n", "c: ", c)



testing = false
epochsize = 500
num_starts = 1

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


#write output header
header_filename = string(results_dir, global_start_time, "_header.txt")
open(header_filename, "w") do f
    write(f, header_string)
end


#cumulative collisions, losses, and number of trials
#total reward, and best average tracking
cum_coll = 0
cum_loss = 0
cum_trials = 0
total_reward = 0
best_average = 1


run_data = []

# trialslambda
num_particles = N
mcts_loss = 0
mcts_coll = 0
run_times = []
result = []
for j in 1:num_starts
    global start
    if start != "false"
        start = df_start[!, j]
        println("Starting point ", j, " of ", num_starts, ": ", start)
    end
    for i = 1:num_runs
        run_start_time = now()
        global mcts_loss, mcts_coll, num_particles, DEPTH, hist, result
        result = mcts_trial(DEPTH, c, num_particles, lambda, start=start, hist=hist)
        mcts_coll += result[3]
        mcts_loss += result[4]
        start_out = result[5]
        hist_out = result[7]
        crs_out = [result[8]]
        print(".")
        push!(run_times, (now()-run_start_time).value)
        push!(run_data, (mcts_coll, mcts_loss))
        CSV.write(string(results_dir, start, "_run_", i,"_hist.csv"), DataFrame([h for h in hist_out]))
        CSV.write(string(results_dir, start, "_run_", i,"_crs.csv"), DataFrame([h for h in crs_out]))
        if i == num_runs # || i % 10 == 10
            println()
            println("==============================")
            println("Trials: ", i)
            println("NUM PARTICLES: ", num_particles)
            println("MCTS Depth ", DEPTH, " Results")
            println("Collision Rate: ", mcts_coll/i)
            println("Loss Rate: ", mcts_loss/i)
            println("==============================")
            namefile = string(results_dir, global_start_time, "_data.csv")
            updated_header = string(header_string, "\nAverage Runtime: ", mean(run_times))
            CSV.write(namefile, DataFrame(run_data))
            open(header_filename, "w") do f
                write(f, updated_header)
            end
        end
    end #num_runs
end #num_starts

# print results




#
