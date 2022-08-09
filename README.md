# :black_nib: RNAseq-SNP-calling

Our Guthub repo include pipelines for large-scale SNP detection from RNA-seq data of different tissues per phenotype. Our pipeline mapped raw sequence reads against the genome using [STAR](https://github.com/alexdobin/STAR) aligner (2-pass method). Uniquely mapped reads were then pre-processed using [GATK](https://github.com/broadinstitute/gatk) Best-Practices pipeline for RNA-seq data. This was followed by variant detection processes, and vigorous filtering of false-positive calls.

# ⚙️Technologies & Tools

![GitHub](https://img.shields.io/badge/github-%23777BB4.svg?style=for-the-badge&logo=github&logoColor=white)
![](https://img.shields.io/badge/OS-Linux-informational?style=flat&logo=<#FF6000>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Code-JavaScript-informational?style=flat&logo=<#FF6000>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/Cromwell-v.55-informational?style=flat&logo=<#23777BB4#>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/STAR-2.7.9-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/picard-2.27.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/GATK-4.2.3.0-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)
![](https://img.shields.io/badge/bcftools-1.9-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)

## 🔗 Quick Start

### 1. Mapping RNA-seq data to the reference using STAR 

In this resaerch, the STAR pipeline was written in [Workflow Description Language (WDL)](https://github.com/openwdl/wdl). 

* **Dependencies**

a. [Docker](https://github.com/docker)

b. [Cromwell](https://github.com/broadinstitute/cromwell)

c. [Java](https://github.com/topics/java)

:heavy_exclamation_mark: For running paired-star-align.wdl you also need to build an **index** from [Gencode-Annotation-File](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/gencode.v31.annotation.gtf.gz) using [STAR](https://github.com/alexdobin/STAR) and save them in a seprated folder. 

* Run the workflow directly by executing the following commands on your terminal:

`java -Dconfig.file=application.conf -jar cromwell-55.jar run paired-star-align.wdl -i paired-star-align.json`

### 2. Pre-processing measures using picard-tools

Use the **Pre-processing-picard.sh** pipeline for this step.

* **Required tools**

a. [picard.jar](https://github.com/broadinstitute/picard)

* **Required data**

a. Bam files produced from STAR aligner

b. [Homo_sapiens_assembly38.dict](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dict?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

### 3. Variant calling steps using GATK Best-Practice pipeline

Use the **Variant-calling-GATK.sh** pipeline for this step.

* **Required tools**

a. [GATK Best Practices](https://github.com/broadinstitute/gatk)

* **Required data**

a. Output of the last step of pre-processing pipeline

b. [Homo_sapiens_assembly38.fasta](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

c. [Homo_sapiens_assembly38.dbsnp138](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

d. [Homo_sapiens_assembly38.dbsnp138.indexed](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

e. [Homo_sapiens_assembly38.known-indels](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

f. [Homo_sapiens_assembly38.known_indels.indexed](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

g. [wgs_calling_regions.hg38.interval_list](https://console.cloud.google.com/storage/browser/_details/genomics-public-data/resources/broad/hg38/v0/wgs_calling_regions.hg38.interval_list?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22)))

### 4. Merge VCFs &  Filteration

Use the **VCFs-merge-filter.sh** pipeline for this step.

* **Required tools**

a. [bcftools](https://github.com/samtools/bcftools)

b. [tabix](https://github.com/samtools/tabix)

c. [GATK Best Practices](https://github.com/broadinstitute/gatk)

* **Required data**

a. A list of selected VCFs 





