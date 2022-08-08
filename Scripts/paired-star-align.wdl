workflow STAR {
    File inputSampleFiles
    Array[Array[File]] files = read_tsv(inputSampleFiles)

scatter(file in files) {

                call Align {
                  input: fastq1=file[0],

                                fastq2=file[1],
                                sample_basename=basename(file[0], ".fq.gz")}
}
}

#########
# Tasks # 
#########

## 1. This task will align the reads to reference
##              using STAR algorithm
task Align {
    File fastq1
    File fastq2
    File index
    String indexfile = select_first([index,"path/to/index/files"])    
    String sample_basename
    String GeneCounts
    String zcat
    String BAM
    String SortedByCoordinate
    String Basic

    command {
  mkdir genome_ref
   cp -r indexfile genome_ref
      STAR --genomeDir ${index} --readFilesIn ${fastq1} ${fastq2} --readFilesCommand ${zcat} --twopassMode ${Basic} --outSAMtype ${BAM} ${SortedByCoordinate} --quantMode ${GeneCounts} --outFileNamePrefix "${sample_basename}"
 }
    output {
        File outbam = "${sample_basename}-aligned"
    }

    runtime 
    {

    docker: "star:1.0"
    cpu: 5
    memory: "40  GB"
        
    }
}
