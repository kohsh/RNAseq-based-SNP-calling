# :black_nib: RNAseq-SNP-calling

# ⚙️Technologies & Tools

![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=lightblue)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=lightblue)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=green)

## Installatoion of associated packages:

* STAR installation

wget [star-2.7.9](https://github.com/alexdobin/STAR/archive/2.7.9a.tar.gz)

`tar -xzf 2.7.9a.tar.gz`

`cd STAR-2.7.9a/source`

`make STAR`

* picard installation

wget [picard.jar](https://github.com/broadinstitute/picard/releases/download/2.27.4/picard.jar)

`java -jar /path/to/picard.jar -h`

* bcftools installation

wget [bcftools](https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2)

`tar -vxjf bcftools-1.9.tar.bz2`

`cd bcftools-1.9`

`make`

* gatk-4.2.3.0 installation

wget [GATK Best Practices](https://github.com/broadinstitute/gatk/releases/download/4.2.3.0/gatk-4.2.3.0.zip)

`unzip gatk-4.2.3.0.zip`

`cd  gatk-4.2.3.0`
    
`java -jar gatk-package-4.2.3.0-local.jar`


## :file_folder: Downloading and organising required data:

wget [wgs_calling_regions.hg38.interval_list](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/wgs_calling_regions.hg38.interval_list?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.known_indels.vcf.gz](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.known_indels.vcf.gz.tbi](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.dbsnp138.vcf](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.dbsnp138.vcf.idx](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.dict](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.fasta](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wgat 


## :mag_right: Steps for SNP calling from RNA-seq data:

* Mapping RNA-seq data to the reference using STAR 

Install JAVA, and Cromwell
Build Docker images for Trimmomatic, fastQC and Kallisto
For running Kallisto.wdl you also need to build an index from a FASTA formatted file of target sequences using Kallisto and name it under gencode.idx.
Run the workflow directly by executing the following commands on your terminal:

* Preprocessing measures using picard-tools

### 1a. [BuildBamIndex-picard](https://gatk.broadinstitute.org/hc/en-us/articles/360037057932-BuildBamIndex-Picard-)

`java -jar picard.jar BuildBamIndex I=${sample}.fastq.gzAligned.sortedByCoord.out.bam`

### 2a. [ReorderSam-picard](https://gatk.broadinstitute.org/hc/en-us/articles/360037426651-ReorderSam-Picard-)

`java -jar picard.jar ReorderSam INPUT=${sample}.fastq.gzAligned.sortedByCoord.out.bam OUTPUT=${sample}_reordered.bam SEQUENCE_DICTIONARY=../References/GRCh38.primary_assembly.genome.dict CREATE_INDEX=true`

### 3a. [AddOrReplaceReadGroups-picard](https://gatk.broadinstitute.org/hc/en-us/articles/360037226472-AddOrReplaceReadGroups-Picard-)

`java -jar picard.jar AddOrReplaceReadGroups INPUT=${sample}_reordered.bam OUTPUT=${sample}_AddReplaceGroup.bam SORT_ORDER=coordinate CREATE_INDEX=true RGID=${sample} RGSM=${sample} RGLB=Fragment RGPL=platform RGCN=center RGPU=${sample}`

### 4a. [MarkDuplicates-picard](https://gatk.broadinstitute.org/hc/en-us/articles/360037052812-MarkDuplicates-Picard-#:~:text=MarkDuplicates%20(Picard)%20Follow,e.g.%20library%20construction%20using%20PCR.)

`java -Xmx32G -jar picard.jar MarkDuplicates INPUT=${sample}_AddReplaceGroup.bam OUTPUT=${sample}_markduplicate.bam CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT METRICS_FILE=${sample}.metrics`

* Variant calling steps by applying the standard criteria of GATK RNA pipeline

### 1b. [SplitNCigarReads-GATK](https://gatk.broadinstitute.org/hc/en-us/articles/360036858811-SplitNCigarReads)

`gatk-4.2.3.0/gatk SplitNCigarReads -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_markduplicate.bam -O ${sample}_SplitNCigar.bam`

### 2b. [BaseRecalibrator-GATK](https://gatk.broadinstitute.org/hc/en-us/articles/360036898312-BaseRecalibrator)

`gatk-4.2.3.0/gatk BaseRecalibrator -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_SplitNCigar.bam --use-original-qualities -O ${sample}_recalibration_report --known-sites ../References/Homo_sapiens_assembly38.dbsnp138.vcf --known-sites ../References/Homo_sapiens_assembly38.known_indels.vcf.gz`

### 3b. [ApplyBQSR-GATK](https://gatk.broadinstitute.org/hc/en-us/articles/360037055712-ApplyBQSR)

`gatk-4.2.3.0/gatk ApplyBQSR --add-output-sam-program-record -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_SplitNCigar.bam --use-original-qualities -O ${sample}_BQSR.bam --bqsr-recal-file ${sample}_recalibration_report`

### 4b. [SplitIntervals-GATK](https://gatk.broadinstitute.org/hc/en-us/articles/360036899592-SplitIntervals)

`gatk-4.2.3.0/gatk SplitIntervals -R ../References/GRCh38.primary_assembly.genome.fa -L ../References/wgs_calling_regions.hg38.interval_list -scatter 10  -O ./interval-files --subdivision-mode BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'`

### 5b. [HaplotypeCaller-GATK](https://gatk.broadinstitute.org/hc/en-us/articles/360037225632-HaplotypeCaller)

`gatk-4.2.3.0/gatk HaplotypeCaller -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_BQSR.bam -L 0000-scattered.interval_list -L 0001 scattered.interval_list -L 0002-scattered.interval_list -L 0003-scattered.interval_list -L 0004-scattered.interval_list -L 0005-scattered.interval_list -L 0006 scattered.interval_list -L 0007-scattered.interval_list -L 0008-scattered.interval_list -L 0009-scattered.interval_list -O ${sample}.vcf.gz -dont-use-soft-clipped-bases -stand-call-conf 20 --dbsnp ../References/Homo_sapiens_assembly38.dbsnp138.vcf --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'`
 
 ### Merge VCFs

`bcftools-1.9/bcftools merge -l AD-PD-WB.txt -Oz -o AD-PD-WB.vcf.gz`

### Index 

`tabix -p vcf .vcf.gz`

### VariantFilteration

`gatk-4.2.3.0/gatk VariantFiltration -R ../References/GRCh38.primary_assembly.genome.fa -V AD-Ct-BA9.vcf.gz --window 35 --cluster 3 --filter-name "FS" --filter "FS > 30.0" --filter-name "QD" --filter "QD < 2.0" -O AD-Ct-BA9_VF.vcf.gz`


