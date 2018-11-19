#!/usr/bin/env bash 
cd ~/Downloads/sniper-6.0/benchmarks
declare -a l3Array=("4MB" "8MB" "16MB")
declare -a coreArray=("1" "2")
declare -a outFiles=("sim.info" "sim.out" "sim.cfg" "sim.stats.sqlite3" "cpi-stack.png" "power.png" "topo.svg" "power.xml" "power.txt" "power.py")
#Problem a b
cp ../project2/nehalem.cfg ../config/nehalem.cfg
for L3 in "${l3Array[@]}"
do
	for core in "${coreArray[@]}"
	do
		cp ../project2/$L3.cfg ../config/gainestown.cfg
		./run-sniper -p splash2-fft -i test -n $core -c gainestown
		echo "--------------Core$core $L3 CPI Stacks--------------"
		../tools/cpistack.py
		echo "-------------Core$core $L3 Power Stacks-------------"
		../tools/mcpat.py
		../tools/gen_topology.py
		dirName="Core$core-$L3"
		mkdir -p $dirName
		for fileName in "${outFiles[@]}"
		do
			mv $fileName "./$dirName/$fileName"
		done
	done
done
#Problem c
cp "../project2/gainestown(L4).cfg" ../config/gainestown.cfg
cp "../project2/nehalem(L4).cfg" ../config/nehalem.cfg
./run-sniper -p splash2-fft -i test -n 1 -c gainestown
echo "--------------Core1 L4=64MB CPI Stacks--------------"
../tools/cpistack.py
echo "-------------Core1 L4=64MB Power Stacks-------------"
../tools/mcpat.py
../tools/gen_topology.py
dirName="Core1-L4"
mkdir -p $dirName
for fileName in "${outFiles[@]}"
do
	mv $fileName "./$dirName/$fileName"
done
