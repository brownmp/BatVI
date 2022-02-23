version 1.0






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Run BatVI
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
task RunBatVI {
    input {
        File fastq1
        File? fastq2

        # Human 
        File Human_BLAST_index
        File Human_BatIndex
        File Human_BWA_Index
        File Human_fasta

        # Virus 
        File Virus_BLAST_index
        File Virus_BatIndex
        File Virus_BWA_Index
        File Virus_fasta

        Int  insertion_length

        Int cpus
        Int preemptible
        String docker
        String sample_id
    }

    command <<<
        set -e



        #~~~~~~~~~~~~~~~~~~~~~~~~
        # Untar the references  
        #~~~~~~~~~~~~~~~~~~~~~~~~
        tar -xvf ~{Human_BLAST_index}
        tar -xvf ~{Human_BatIndex}
        tar -xvf ~{Human_BWA_Index}

        tar -xvf ~{Virus_BLAST_index}
        tar -xvf ~{Virus_BatIndex}
        tar -xvf ~{Virus_BWA_Index}


        #~~~~~~~~~~~~~~~~~~~~~~~~
        # Run BatVI
        #   two specific cases 
        #       with two fastqs tared togeter and seperate 
        #~~~~~~~~~~~~~~~~~~~~~~~~
        # special case for tar of fastq files
        if [[ "~{fastq1}" == *.tar.gz ]]
        then
            mkdir fastq
            tar -xvf ~{fastq1} -C fastq
            rm ~{fastq1}
            #fastqs=$(find fastq -type f)
            fastqs=($(pwd)/fastq/*)
            fastq1="${fastqs[0]}"
            fastq2="${fastqs[1]}"

            # Write configuration and filelist files
            ./BatVI/write_configuration_file.py \
                --fastq1 $fastq1,
                --fastq2 $fastq2,
                --Human_BLAST_index ~{Human_BLAST_index},
                --Human_BatIndex ~{Human_BatIndex},
                --Human_BWA_Index ~{Human_BWA_Index},
                --Human_fasta ~{Human_fasta},
                --Virus_BLAST_index ~{Virus_BLAST_index},
                --Virus_BatIndex ~{Virus_BatIndex},
                --Virus_BWA_Index ~{Virus_BWA_Index},
                --Virus_fasta ~{Virus_fasta}
                --insertion_length ~{insertion_length}
        
            #~~~~~~~~~~~~~~~~~~~~~~~
            # Run BatVI
            #~~~~~~~~~~~~~~~~~~~~~~~
            /usr/local/src/batvi1.03/call_integrations.sh /usr/local/src/ \
                --threads ~{cpus}  \
                2>&1 | tee output/output_log_subset.txt
        
        else 

            # Write configuration and filelist files
            ./BatVI/write_configuration_file.py \
                --fastq1 ~{fastq1},
                --fastq2 ~{fastq2},
                --Human_BLAST_index ~{Human_BLAST_index},
                --Human_BatIndex ~{Human_BatIndex},
                --Human_BWA_Index ~{Human_BWA_Index},
                --Human_fasta ~{Human_fasta},
                --Virus_BLAST_index ~{Virus_BLAST_index},
                --Virus_BatIndex ~{Virus_BatIndex},
                --Virus_BWA_Index ~{Virus_BWA_Index},
                --Virus_fasta ~{Virus_fasta}
                --insertion_length ~{insertion_length}
        
            #~~~~~~~~~~~~~~~~~~~~~~~
            # Run BatVI
            #~~~~~~~~~~~~~~~~~~~~~~~
            /usr/local/src/batvi1.03/call_integrations.sh /usr/local/src/ \
                --threads ~{cpus}  \
                2>&1 | tee output/output_log_subset.txt
        fi

        #~~~~~~~~~~~~~~~~~~~~~~~~
        # Tar the output
        #~~~~~~~~~~~~~~~~~~~~~~~~
        tar -czf OUTPUT.tar.gz OUTPUT

    >>>

    output {
        File output_file="OUTPUT.tar.gz"
    }

    runtime {
        preemptible: preemptible
        disks: "local-disk " + ceil(size(Human_BLAST_index, "GB") + size(Human_BatIndex, "GB") + size(Human_BWA_Index, "GB") + size(fastq1, "GB")*6 + 100) + " HDD"
        docker: docker
        cpu: cpus
        memory: "100GB"
    }
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Workflow
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

workflow BatVI {
    input {

        #~~~~~~~~~~~~
        # Sample ID
        #~~~~~~~~~~~~
        String sample_id
      
        #~~~~~~~~~~~~
        # FASTQ Files
        #~~~~~~~~~~~~
        File left
        File? right

        #~~~~~~~~~~~~
        # CPU count 
        #~~~~~~~~~~~~
        Int cpus = 10

        #~~~~~~~~~~~~
        # Reference Directories 
        #~~~~~~~~~~~~
        # Human 
        File Human_BLAST_index
        File Human_BatIndex
        File Human_BWA_Index
        File Human_fasta

        # Virus 
        File Virus_BLAST_index
        File Virus_BatIndex
        File Virus_BWA_Index
        File Virus_fasta

        Int insertion_length 

        #~~~~~~~~~~~~
        # general runtime settings
        #~~~~~~~~~~~~
        Int preemptible = 2
        String docker = "brownmp/batvi:devel"

        

    }

    parameter_meta {
        left:{help:"One of the two paired RNAseq samples"}
        right:{help:"One of the two paired RNAseq samples"}
        cpus:{help:"CPU count"}
        docker:{help:"Docker image"}
    }


    #########################
    # run using given references 
    #########################
    call RunBatVI{
        input:
            fastq1 = left,
            fastq2 = right,

            Human_BLAST_index = Human_BLAST_index,
            Human_BatIndex    = Human_BatIndex,
            Human_BWA_Index   = Human_BWA_Index,
            Human_fasta       = Human_fasta,

            Virus_BLAST_index = Virus_BLAST_index,
            Virus_BatIndex    = Virus_BatIndex,
            Virus_BWA_Index   = Virus_BWA_Index,
            Virus_fasta       = Virus_fasta,

            insertion_length  = insertion_length,
            
            cpus            = cpus,
            preemptible     = preemptible,
            docker          = docker,
            sample_id       = sample_id
    }
}
