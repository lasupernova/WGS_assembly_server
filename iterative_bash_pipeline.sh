#!/bin/bash 

#clear screen for better readability
clear 

# get date when script started
dt=`date '+%d/%m/%Y %H:%M:%S'`

# change directory to script directory -->  to not have problems with relative paths in script

scriptdir="$(dirname "$0")"
cd "$scriptdir"

# define flag, help and error messages

usage() {                                 
  echo "Usage: $0 [-h HELP] [ -i ID <integer> ] [ -f FORWARD_SUFFIX <integer|string> ] [ -r REVERSE_SUFFIX <integer|string>] [ -t TYPE <meta|isolate>]" 1>&2 
}
exit_abnormal() {             
  usage
  exit 1
}
 
while getopts ":i:f:t:o:h" option
do
case $option
in
i) ID="$OPTARG"; echo "The first $ID characters of the file name will be used as identifiers." ;;
f) FORWARD_SUFFIX=${OPTARG}; echo "Forward reads have the following suffix: $FORWARD_SUFFIX" ;;
t) TYPE=${OPTARG}; [[ $TYPE == 'meta' || $TYPE == 'isolate' ]] || usage ;;
o) ORIGIN=${OPTARG};;
h) echo "


***HELP SECTION***

	The following parameters are necessary:
			
	[-i ID] type the number of character from the beginning of the file name, that are needed to identify this file
	[-f FORWARD_SUFFIX] type the suffix used to distinguish forward and reverse reads; e.g 'FW/RV' or 'R1/R2'
	[-t TYPE] the type of analysis needed; there are two options metagenomes or isolates"
	[-o ORIGIN] type the name of the origin folder, where the fasta files are stored
esac
done

# iterate over files and run SPAdes

x=$((1))
ORIGIN="../$ORIGIN"

# define log file path
log=$ORIGIN/info.log

# log output
echo -e "This script is running from the following folder: $scriptdir


Assembly pipeline started at $dt .

The following settings are being used:
	-type of assembly= $TYPE  [-t]
	-suffix for forward reads: $FORWARD_SUFFIX  [-f]
	-number of characters from file used to identify the sample: $ID  [-i]
	-project folder name: $ORIGIN  [-o]
\n" |tee $log


# compute path length before file name to delete this section from output folder name 
orilen=$((${#ORIGIN}+1))

# compute new ID length necessary, taking into account orlen
ID=$((orilen+ID))

for f in $ORIGIN/*.fastq ; \
	do if [[ $f =~ $FORWARD_SUFFIX ]]
	then
		sample=${f:orilen:ID}
		echo -e  "\n\n\n Sample $x is named: $sample" | tee -a $log
	        x=$((x+=1))
		number_of_files=$(ls $ORIGIN/* | grep ${f:orilen:ID} | wc -l)
		
		if [[ $number_of_files -lt 2  ]]
		then
			echo "ERROR: more than 2 files with the identifier $sample
			Please choose a larger ID length [-i] or delete duplicates from folder." 
		else
			file1=$(ls $ORIGIN/* | grep ${f:orilen:ID} -m1)
			file2=$(ls $ORIGIN/* | grep ${f:orilen:ID} -m2 |tail -n1)
   			if [[ $file1 =~ "R1"  ]]
			then
				FW=$file1
				RV=$file2
			else
				FW=$file2
				RV=$file1
			fi
		fi
		echo "Forward reads taken from file: $FW" | tee -a $log
		echo "Reverse reads taken from file: $RV" | tee -a $log
		output_folder_name=${file1:orilen:ID}
		output_path="$ORIGIN/$output_folder_name"
		echo "$output_folder_name being processed"
		echo "Output will be found in: $output_path" | tee -a $log
		echo -e "\n" | tee -a $log

		if [[ $TYPE == 'meta'  ]]
		then
					sbatch spades_script_40threads_180G_META_input_from_iteration.sh $FW $RV $output_path | tee -a $log
		elif [[ $TYPE == 'isolate'  ]]
		then
					sbatch spades_script_40threads_180G_Isolate.sh $FW $RV $output_path  | tee -a $log
		else
			echo "ERROR: Please specify the sample type! [-t] Metagenome or Isolate." | tee -a $log
		fi
		echo -e "\n" | tee -a $log
	fi;
done

# output information on running processes AFTER loop

echo "

*********************************************
$((`squeue -u pauluga | wc -l` -1)) samples are being processed on the server.

`squeue -u pauluga`

Check back in a few hours to check if the assembly is finished.

The status of the running assemblies can be checked by using the following command:
 'squeue -u <username>'          e.g.: squeue -u pauluga

To cancel ALL jobs running/pending on the server use the following command:
 'scancel -u <username>'

To cancel a specific job for example due to errors thrown, please use the jobID specified above and use the following command:
 'scancel <jobID>'

For more detailed information, please check the info.log file in the following folder: $ORIGIN or open the README file in the main folder.
Credit: Gabriela K. Paulus
********************************************"

