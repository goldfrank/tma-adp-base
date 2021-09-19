#!/bin/fish
# mcts script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../results/"$inner_folder
echo $folder
mkdir $folder

julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run1.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run2.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run3.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run4.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run5.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run6.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run7.csv" --hist "false" &
julia --project=.. mcts.jl --trials 10 --N 500 --depth 5 --iterations 500 --c 1 --lambda 0.95 --results_dir $folder --start "../starts/run8.csv" --hist "false" 
