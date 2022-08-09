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

wget [gencode.v31.annotation.gtf.gz](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/gencode.v31.annotation.gtf.gz)

* Required for pre-processing step using picard-tools
wget [Homo_sapiens_assembly38.dict](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

* Required for variant calling step using GATK Best-Practice pipeline

wget [Homo_sapiens_assembly38.fasta](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.dbsnp138.vcf](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.dbsnp138.vcf.idx](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.known_indels.vcf.gz](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [Homo_sapiens_assembly38.known_indels.vcf.gz.tbi](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

wget [wgs_calling_regions.hg38.interval_list](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/wgs_calling_regions.hg38.interval_list?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))


## Steps for calling SNPs from RNA-seq data
### 🔗 Quick Start

* Mapping RNA-seq data to the reference using STAR 

In this resaerch, the STAR pipeline was written in [Workflow Description Language (WDL)](https://github.com/openwdl/wdl). Please use the following command to run the scripts provided.

`java -Dconfig.file=application.conf -jar cromwell-55.jar run paired-star-align.wdl -i paired-star-align.json`

* Preprocessing measures using picard-tools

* Merge VCFs & Indexing

* Filteration of called SNPs



