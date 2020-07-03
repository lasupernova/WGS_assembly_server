#!/bin/bash 
#SBATCH --time=6:00:00
#SBATCH --account=[fill_in_account_name]
#SBATCH --mem=180G
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1
#SBATCH -o $3/slurm
# load the module
module load nixpkgs/16.09
module load gcc/7.3.0
module load spades/3.13.0
# List module loaded
module list
echo
spades.py --careful --threads 40 -1 $1 -2 $2 -o $3 --mem=180

