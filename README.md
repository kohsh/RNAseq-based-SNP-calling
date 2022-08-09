# :black_nib: RNAseq-SNP-calling

# ⚙️Technologies & Tools

![GitHub](https://img.shields.io/badge/github-%23777BB4.svg?style=for-the-badge&logo=github&logoColor=white)
![](https://img.shields.io/badge/OS-Linux-informational?style=flat&logo=<#FF6000>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Code-JavaScript-informational?style=flat&logo=<#FF6000>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Cromwell-v.55-informational?style=flat&logo=<#23777BB4#>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/STAR-2.7.9-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/picard-2.27.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/GATK-4.2.3.0-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/bcftools-2.27.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)

## Installatoion of associated packages

* STAR installation

wget [star-2.7.9](https://github.com/alexdobin/STAR/archive/2.7.9a.tar.gz)

`tar -xzf 2.7.9a.tar.gz`

`cd STAR-2.7.9a/source`

`make STAR`

* picard installation

wget [picard.jar](https://github.com/broadinstitute/picard/releases/download/2.27.4/picard.jar)

`java -jar /path/to/picard.jar -h`

* gatk-4.2.3.0 installation

wget [GATK Best Practices](https://github.com/broadinstitute/gatk/releases/download/4.2.3.0/gatk-4.2.3.0.zip)

`unzip gatk-4.2.3.0.zip`

`cd  gatk-4.2.3.0`
    
`java -jar gatk-package-4.2.3.0-local.jar`

* bcftools installation

wget [bcftools](https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2)

`tar -vxjf bcftools-1.9.tar.bz2`

`cd bcftools-1.9`

`make`

## :file_folder: Downloading and organising required data

* Gene annotation file required for STAR alignment



* Required for pre-processing step using picard-tools



* Required for variant calling step using GATK Best-Practice pipeline



## Steps for calling SNPs from RNA-seq data

### 🔗 Quick Start

1. Mapping RNA-seq data to the reference using STAR 

In this resaerch, the STAR pipeline was written in [Workflow Description Language (WDL)](https://github.com/openwdl/wdl). 

**Dependencies**

a. [Docker](https://github.com/docker)

b. [Cromwell](https://github.com/broadinstitute/cromwell/releases)

c. [Java](https://github.com/topics/java)

d. wget [gencode.v31.annotation.gtf.gz](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/gencode.v31.annotation.gtf.gz)

:heavy_exclamation_mark: For running paired-star-align.wdl you also need to build an **index** from a GTF formatted file of target sequences using [STAR](https://github.com/alexdobin/STAR) and save them in a seprated folder. 

* Run the workflow directly by executing the following commands on your terminal:

`java -Dconfig.file=application.conf -jar cromwell-55.jar run paired-star-align.wdl -i paired-star-align.json`

2. Pre-processing measures using picard-tools

**Required tools**

a. wget [picard.jar](https://github.com/broadinstitute/picard/releases/download/2.27.4/picard.jar)

`java -jar /path/to/picard.jar -h`

**Required data**

a. Bam files produced from STAR aligner

b. wget [Homo_sapiens_assembly38.dict](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

3. Variant calling steps using GATK Best-Practice pipeline

**Required tools**

wget [GATK Best Practices](https://github.com/broadinstitute/gatk/releases/download/4.2.3.0/gatk-4.2.3.0.zip)

`unzip gatk-4.2.3.0.zip`

`cd  gatk-4.2.3.0`
    
`java -jar gatk-package-4.2.3.0-local.jar`

**Required data**

a. Output of the last step of pre-processing pipeline

b. wget [Homo_sapiens_assembly38.fasta](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

c. wget [Homo_sapiens_assembly38.dbsnp138](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

d. wget [Homo_sapiens_assembly38.dbsnp138.indexed](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

e. wget [Homo_sapiens_assembly38.known-indels](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

f. wget [Homo_sapiens_assembly38.known_indels.indexed](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

g. wget [wgs_calling_regions.hg38.interval_list](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/wgs_calling_regions.hg38.interval_list?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

4. Merge VCFs & Indexing

**Required tools**

a. wget [bcftools](https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2)

`tar -vxjf bcftools-1.9.tar.bz2`

`cd bcftools-1.9`

`make`

**Required data**


4. Filteration of called SNPs



