#!/bin/fish
# q_lambda script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../q_results/"$inner_folder
echo $folder
mkdir $folder

#julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 1000 --N 4000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.95 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 1000 --N 4000 --gamma 0.95 --lambda 0.95 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 5000 --N 500 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "zeros" --alpha 0.05 &
julia --project=.. q_lambda.jl --trials 5000 --N 500 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/original_weights.csv" --alpha 0.1 &
julia --project=.. q_lambda.jl --trials 5000 --N 500 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/original_weights.csv" --alpha 0.05 &
#julia --project=.. q_lambda.jl --trials 5000 --N 500 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "zeros" --alpha 0.3 &

# julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "zeros" --hist "../starts/crs2.csv"
