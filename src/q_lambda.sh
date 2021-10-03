#!/bin/fish
# q_lambda script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../q_results/"$inner_folder
echo "Saving to: " $folder
mkdir $folder
set filename ../starts/run
set trials 10
for n in 250 500 750 #1000
  set folder "../q_results/"$inner_folder"_n_"$n"/"
  echo "Saving results to: "$folder
  mkdir $folder
  for i in 1 2 3 4 5 6 7 8
    date
    echo "Running N = " $n
    set in_name "$filename$i.csv"
    julia --project=.. q_lambda.jl --trials $trials --N $n --results_dir $folder --theta "../weights/1000_weights.csv" --alpha 0.0 --start $in_name &
  end
  wait
end
