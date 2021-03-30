#!/bin/fish
# q_lambda script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../"$inner_folder
echo $folder
mkdir $folder

julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../TueMar23183459EDT2021/2021-03-23T18_35_10.877_weights.csv" &
julia --project=.. q_lambda.jl --trials 1000 --N 4000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../TueMar23183459EDT2021/2021-03-23T18_35_10.989_weights.csv" &
julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.95 --results_dir $folder --theta "../TueMar23183459EDT2021/2021-03-23T18_35_10.921_weights.csv" &
julia --project=.. q_lambda.jl --trials 1000 --N 4000 --gamma 0.95 --lambda 0.95 --results_dir $folder --theta "../TueMar23183459EDT2021/2021-03-23T18_35_10.928_weights.csv" &


# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 5 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 15 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 20 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 25 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 30 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 35 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 40 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 45 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 50 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 55 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 60 --gamma 0.90 --results_dir $folder &
#
# wait
#
# julia mcts.jl --trials 1000 --N 100 --depth 1 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 3 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 5 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 7 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 14 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 17 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 19 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 22 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 26 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
# julia mcts.jl --trials 1000 --N 100 --depth 30 --iterations 200 --c 10 --gamma 0.90 --results_dir $folder &
#
# wait

# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.3 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.4 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.5 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.6 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.6 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.7 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.8 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.875 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.9 --results_dir 2$folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.925 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.95 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.95 --results_dir $folder &
# julia mcts.jl --trials 3000 --N 100 --depth 10 --iterations 200 --c 10 --gamma 0.975 --results_dir $folder &
