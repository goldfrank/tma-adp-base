#!/bin/fish
# q_lambda script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../q_results/"$inner_folder
echo "Saving to: " $folder
mkdir $folder
set filename ../starts/run

#julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 1000 --N 4000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.95 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 1000 --N 4000 --gamma 0.95 --lambda 0.95 --results_dir $folder --theta "../q_results/SatSep25144026EDT2021/weights2.csv" &
#julia --project=.. q_lambda.jl --trials 5000 --N 500 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "zeros" --alpha 0.05 &
# julia --project=.. q_lambda.jl --trials 5000 --N 1000 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/updated_weights.csv" --alpha 0.1 &
# julia --project=.. q_lambda.jl --trials 5000 --N 1000 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/updated_weights.csv" --alpha 0.05 &
# julia --project=.. q_lambda.jl --trials 5000 --N 1000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "../weights/updated_weights.csv" --alpha 0.05 &
# julia --project=.. q_lambda.jl --trials 5000 --N 1000 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/updated_weights.csv" --alpha 0.025 &
# julia --project=.. q_lambda.jl --trials 5000 --N 2000 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/updated_weights.csv" --alpha 0.05 &
# julia --project=.. q_lambda.jl --trials 5000 --N 2000 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "../weights/updated_weights.csv" --alpha 0.025 &
#julia --project=.. q_lambda.jl --trials 5000 --N 500 --gamma 0.9 --lambda 0.9 --results_dir $folder --theta "zeros" --alpha 0.3 &

# julia --project=.. q_lambda.jl --trials 1000 --N 3000 --gamma 0.95 --lambda 0.9 --results_dir $folder --theta "zeros" --hist "../starts/crs2.csv"


set trials 10
for n in 250 500 750 1000 2000 4000
  set folder "../q_results/"$inner_folder"_n_"$n"/"
  echo "Saving results to: "$folder
  mkdir $folder
  for i in 1 2 3 4 5 6 7 8
    date
    echo "Running N = " $n
    set in_name "$filename$i.csv"
    julia --project=.. q_lambda.jl --trials $trials --N $n --results_dir $folder --theta "../weights/final_weights.csv" --alpha 0.0 --start $in_name &
  end
  wait
end
