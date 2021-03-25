#!/bin/bash
# rsync script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../"$inner_folder
echo $folder
mkdir $folder

julia --project=.. mcts.jl --trials 3000 --N 100 --depth 7 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 3000 --N 100 --depth 7 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 3000 --N 100 --depth 13 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 2000 --N 100 --depth 13 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 2000 --N 100 --depth 15 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 2000 --N 100 --depth 15 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 2000 --N 100 --depth 19 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 2000 --N 100 --depth 19 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &
julia --project=.. mcts.jl --trials 2000 --N 100 --depth 19 --iterations 200 --c 10 --lambda 0.80 --results_dir $folder &


# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 5 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 15 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 20 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 25 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 30 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 35 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 40 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 45 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 50 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 55 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 60 --lambda 0.90 --results_dir $folder &
#
# wait
#
# julia mcts.jl --trials 1000 --N 100 --depth 1 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 3 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 7 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 14 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 17 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 19 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 22 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 26 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 30 --iterations 200 --c 10 --lambda 0.90 --results_dir $folder &
#
# wait

# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.3 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.4 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.5 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.6 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.6 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.7 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.8 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.875 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.9 --results_dir 2$folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.925 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.95 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.95 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --lambda 0.975 --results_dir $folder &
