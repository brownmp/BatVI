#!/usr/bin/env python3
# -*- coding: utf-8 -*-


####################
# Preliminary 
####################
#~~~~~~~~~~~~~~~~~~
# import packages 
#~~~~~~~~~~~~~~~~~~
import argparse
import os

def main():
    ###############################
    # Inputs
    ###############################
    
    #~~~~~~~~~~~~~~~~~~~~
    # Specify the inputs 
    #~~~~~~~~~~~~~~~~~~~~
    parser = argparse.ArgumentParser(   formatter_class = argparse.RawTextHelpFormatter, 
                                        description     = "")
    # parser.add_argument('--fastqs',  required = True,  nargs='+', help = "fastq File input, or a directory holding one or two.")
    parser.add_argument('--fastq1',  required = True,  help = "fastq File input")
    parser.add_argument('--fastq2',  required = True,  help = "fastq File input")
    # Human References
    parser.add_argument('--Human_BLAST_Index', required = True, help = "")
    parser.add_argument('--Human_BatIndex', required = True, help = "")
    parser.add_argument('--Human_BWA_Index', required = True, help="")
    parser.add_argument('--Human_fasta', required = True,  default = "ref_genome_noCHR.fa", help="Human fasta file name")
    #Viral References 
    parser.add_argument('--Virus_BLAST_Index', required = True, help="")
    parser.add_argument('--Virus_BatIndex', required = True, help="")
    parser.add_argument('--Virus_BWA_Index', required = True, help="")
    parser.add_argument('--Virus_fasta', required = True,  default = "HPVs_db.fasta",help="Virus fasta file name")

    parser.add_argument('--insertion_length', required = False, default = 100, help="")
    

    # parser.add_argument('--cpus', required = False, default = "8", help = "threads")
    args = parser.parse_args()

    #~~~~~~~~~~~~~~~~~
    # Parse the inputs 
    # FastQs
    fastq1 = args.fastq1
    fastq2 = args.fastq2
    # human references
    Human_BLAST_Index_input = args.Human_BLAST_Index
    Human_BatIndex_input = args.Human_BatIndex
    Human_BWA_Index_input = args.Human_BWA_Index
    Human_fasta = args.Human_fasta

    # Virus References 
    Virus_BLAST_Index_input = args.Virus_BLAST_Index
    Virus_BatIndex_input = args.Virus_BatIndex
    Virus_BWA_Index_input = args.Virus_BWA_Index
    Virus_fasta = args.Virus_fasta

    insertion_length = args.insertion_length




    def configurePath( fn: str, 
                        extensions=[".tar.bz2", ".tar.gz"]):
        for ext in extensions:
            if fn.endswith(ext):
                new_path = fn[: -len(ext)]
        return os.path.basename(new_path)


    #~~~~~~~~~~~~~~~~
    # Get base names 
    #~~~~~~~~~~~~~~~~
    Human_BLAST_basename = configurePath(Human_BLAST_Index_input)
    Human_BatIndex = configurePath(Human_BatIndex_input)
    Human_BWA_Index = configurePath(Human_BWA_Index_input)

    Virus_BLAST_Index = configurePath(Virus_BLAST_Index_input)
    Virus_BatIndex = configurePath(Virus_BatIndex_input)
    Virus_BWA_Index = configurePath(Virus_BWA_Index_input)

    #~~~~~~~~~~~~~~~~
    # comprise  the paths 
    #~~~~~~~~~~~~~~~~
    cwd = os.getcwd()

    Human_BLAST_Index = os.path.join(cwd, Human_BLAST_basename, Human_fasta)
    Human_BatIndex = os.path.join(cwd, Human_BatIndex, Human_fasta)
    Human_BWA_Index = os.path.join(cwd, Human_BWA_Index, Human_fasta)

    Virus_BLAST_Index = os.path.join(cwd, Virus_BLAST_Index, Virus_fasta)
    Virus_BatIndex = os.path.join(cwd, Virus_BatIndex, Virus_fasta)
    Virus_BWA_Index = os.path.join(cwd, Virus_BWA_Index, Virus_fasta)
    

    a = f"""
    #~~~~~~~~~~~~~~~~~
    # virus database
    #~~~~~~~~~~~~~~~~~
    INDEX={Virus_BatIndex}
    PATHOGEN_BLAST_DB={Virus_BLAST_Index}
    PATHOGEN_BWA={Virus_BWA_Index}

    #~~~~~~~~~~~~~~~~~
    # HumanGenome database
    #~~~~~~~~~~~~~~~~~
    HG_BLAST_DB={Human_BLAST_Index}
    HG_GENOME={Virus_BatIndex}
    HG_BWA={Virus_BWA_Index}


    #~~~~~~~~~~~~~~~~~
    # Toolss
    #~~~~~~~~~~~~~~~~~
    BLAST_PATH=/usr/local/src/ncbi-blast-2.12.0+/bin
    BWA_PATH=/usr/local/bin/
    PICARD_PATH=/usr/local/src/picard.jar
    SAMTOOLS_PATH=/usr/local/bin/
    BEDTOOLS_PATH=/usr/local/bin/
    """

    print("#~~~~~~~~~~~~~~~~~~~~~~~~\nWriting Configuration file\n#~~~~~~~~~~~~~~~~~~~~~~~~")
    output_file = open("batviconfig.txt", "w")
    output_file.write(a)
    output_file.close()



    #########################################
    # Create the File List 
    #########################################
    a = f"{fastq1};{fastq2};{insertion_length}"
    print("#~~~~~~~~~~~~~~~~~~~~~~~~\nWriting FileList.txt file\n#~~~~~~~~~~~~~~~~~~~~~~~~")
    output_file = open("filelist.txt", "w")
    output_file.write(a)
    output_file.close()




if __name__ == '__main__':
    main()