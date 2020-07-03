# WGS_assembly_server<br><br>
### Assembly<br>
Iterative assembly pipeline for assembly of NGS reads using (meta-)SPAdes on computing cluster <br>
<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5411777/">Nurk, S., Meleshko, D., Korobeynikov, A., & Pevzner, P. A. (2017). metaSPAdes: a new versatile metagenomic assembler. Genome research, 27(5), 824-834.</a><br><br>
The script named “iterative_bash.sh”, automates SPAdes use and output as well as definition of sbatch parameters. The script does so iteratively if multiple files need to be converted. This script will solely run on servers not on local hosts.
    <br>1. Check that you are in the spades folder ```pwd``` (if no  navigate to spades-folder using ```cd``` –command) 
    <br>2. Create folder for files to convert in spades folder
```Mkdir <project_folder_name>```
    <br>3. Add raw NGS read files (fw+rv reads; unpaired) in .fastq format to the project folder.
    <br>4. Run automation script using the following command (for detailed information and explanations, see detailed README file):
<br>&nbsp;&nbsp;&nbsp;&nbsp;```sbatch path_to_directory/ iterative_bash.sh -o <Project_folder_name> -i <Integer> -t <meta|isolate> -f <string>``` </pre>
    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. [optional] Transfer newly created assembled .fasta files and any other relevant information to local computer 
    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(e.g. using Global Connect Personal)
    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6. [optional] Delete project folder to avoid cluttering of the spades main folder
```Rmdir <project_folder_name>``` <br><br>
### _.fastq_ to _.fasta_ converter <br>

Conversion of .fastq to .fasta files. The script performs conversion iteratively if multiple files need to be converted.
    <br>1. Check that you are in the _spades_ folder: 
```pwd```
    <br>2. Create folder for files to convert in spades folder:
```mkdir <conversion_folder_name>```
    3. Run conversion script using the following command (sbatch command usually not necessary):
 <br>&nbsp;&nbsp;&nbsp;&nbsp;```Path_to_Folder/fastq_to_fasta_converter.sh <conversion_folder_name>```  
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. [optional] Transfer newly converted _.fasta_ files to local computer (e.g. using Global Connect Personal)
    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. [optional] Delete conversion folder to avoid cluttering of directory
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;```rmdir <conversion_folder_name>```
