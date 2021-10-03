#!/bin/fish
# mcts script

set inner_folder (date | sed 's/ //g' | sed 's/://g')"/"
echo $inner_folder
set folder "../results/"$inner_folder
#echo $folder
mkdir $folder
set filename ../starts/run

set trials 5000
# for n in 250 500 750 1000
for n in 5
  for c in 1.0
    for l in 95
      for d in 1
        set folder "../results/"$inner_folder"d_"$d"_l_"$l"_c_"$c"_n_"$n"/"
        mkdir $folder
        echo $folder
          date
          echo "Running N = " $n "   c =" $c "   lambda = " $l "  delta = " $d
          set in_name "$filename$i.csv"
          julia --project=.. mcts.jl --trials $trials --N $n --depth $d --iterations 10 --c 1 --lambda $l --results_dir $folder --hist "false" &
      end
    end
  end
end
