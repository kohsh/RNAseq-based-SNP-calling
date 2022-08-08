# :black_nib: RNA-seq-SNP-calling

# ⚙️Technologies & Tools

![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=lightblue)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=pink)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)

## Installatoion of associated packages:

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

# :file_folder: Downloading required data


`java -jar picard.jar BuildBamIndex I=${sample}_1.fastq.gzAligned.sortedByCoord.out.bam`

`java -jar picard.jar ReorderSam INPUT=${sample}.fastq.gzAligned.sortedByCoord.out.bam OUTPUT=${sample}_reordered.bam SEQUENCE_DICTIONARY=/media/boris/kosar/Analysis/STAR/References/GRCh38.primary_assembly.genome.dict CREATE_INDEX=true`


`java -jar picard.jar AddOrReplaceReadGroups INPUT=${sample}_reordered.bam OUTPUT=${sample}_AddReplaceGroup.bam SORT_ORDER=coordinate CREATE_INDEX=true RGID=${sample} RGSM=${sample} RGLB=Fragment RGPL=platform RGCN=center RGPU=${sample}`

`java -Xmx32G -jar picard.jar MarkDuplicates INPUT=${sample}_AddReplaceGroup.bam OUTPUT=${sample}_markduplicate.bam CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT METRICS_FILE=${sample}.metrics`

`gatk-4.2.3.0/gatk SplitNCigarReads -R /media/boris/kosar/Analysis/STAR/References/GRCh38.primary_assembly.genome.fa -I ${sample}_markduplicate.bam -O ${sample}_SplitNCigar.bam`

`gatk-4.2.3.0/gatk BaseRecalibrator -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_SplitNCigar.bam --use-original-qualities -O ${sample}_recalibration_report --known-sites ../References/Homo_sapiens_assembly38.dbsnp138.vcf --known-sites ../References/Homo_sapiens_assembly38.known_indels.vcf.gz`

`gatk-4.2.3.0/gatk ApplyBQSR --add-output-sam-program-record -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_SplitNCigar.bam --use-original-qualities -O ${sample}_BQSR.bam --bqsr-recal-file ${sample}_recalibration_report`

`gatk-4.2.3.0/gatk SplitIntervals -R ../References/GRCh38.primary_assembly.genome.fa -L ../References/wgs_calling_regions.hg38.interval_list -scatter 10  -O ./interval-files --subdivision-mode BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'`

`gatk-4.2.3.0/gatk HaplotypeCaller -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_BQSR.bam -L 0000-scattered.interval_list -L 0001 scattered.interval_list -L 0002-scattered.interval_list -L 0003-scattered.interval_list -L 0004-scattered.interval_list -L 0005-scattered.interval_list -L 0006 scattered.interval_list -L 0007-scattered.interval_list -L 0008-scattered.interval_list -L 0009-scattered.interval_list -O ${sample}.vcf.gz -dont-use-soft-clipped-bases -stand-call-conf 20 --dbsnp ../References/Homo_sapiens_assembly38.dbsnp138.vcf --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'`
 
 ### Merge VCFs

`bcftools-1.9/bcftools merge -l AD-PD-WB.txt -Oz -o AD-PD-WB.vcf.gz`

### Index 

`tabix -p vcf .vcf.gz`

### VariantFilteration

`gatk-4.2.3.0/gatk VariantFiltration -R ../References/GRCh38.primary_assembly.genome.fa -V AD-Ct-BA9.vcf.gz --window 35 --cluster 3 --filter-name "FS" --filter "FS > 30.0" --filter-name "QD" --filter "QD < 2.0" -O AD-Ct-BA9_VF.vcf.gz`


