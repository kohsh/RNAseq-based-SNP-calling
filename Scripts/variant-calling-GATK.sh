### Variant calling steps by applying the standard criteria of GATK RNA pipeline ###

# 1b. SplitNCigarReads-GATK

gatk-4.2.3.0/gatk SplitNCigarReads -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_markduplicate.bam -O ${sample}_SplitNCigar.bam

# 2b. BaseRecalibrator-GATK

gatk-4.2.3.0/gatk BaseRecalibrator -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_SplitNCigar.bam 
--use-original-qualities -O ${sample}_recalibration_report --known-sites ../References/Homo_sapiens_assembly38.dbsnp138.vcf --known-sites ../References/Homo_sapiens_assembly38.known_indels.vcf.gz

# 3b. ApplyBQSR-GATK

gatk-4.2.3.0/gatk ApplyBQSR --add-output-sam-program-record -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_SplitNCigar.bam 
--use-original-qualities -O ${sample}_BQSR.bam --bqsr-recal-file ${sample}_recalibration_report

# 4b. SplitIntervals-GATK

gatk-4.2.3.0/gatk SplitIntervals -R ../References/GRCh38.primary_assembly.genome.fa -L ../References/wgs_calling_regions.hg38.interval_list 
-scatter 10 -O ./interval-files --subdivision-mode BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'

# 5b. HaplotypeCaller-GATK

gatk-4.2.3.0/gatk HaplotypeCaller -R ../References/GRCh38.primary_assembly.genome.fa -I ${sample}_BQSR.bam 
-L 0000-scattered.interval_list -L 0001 scattered.interval_list -L 0002-scattered.interval_list -L 0003-scattered.interval_list 
-L 0004-scattered.interval_list -L 0005-scattered.interval_list -L 0006 scattered.interval_list -L 0007-scattered.interval_list 
-L 0008-scattered.interval_list -L 0009-scattered.interval_list -O ${sample}.vcf.gz -dont-use-soft-clipped-bases 
-stand-call-conf 20 --dbsnp ../References/Homo_sapiens_assembly38.dbsnp138.vcf --java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'

### Merge VCFs & Indexing ###

# 6b. bcftools

bcftools-1.9/bcftools merge -l list-of-selected-VCFs.txt -Oz -o selected.vcf.gz 
& 
tabix -p vcf selected.vcf.gz

### Filteration of called SNPs ###

# 7b. VariantFilteration-GATK

gatk-4.2.3.0/gatk VariantFiltration -R ../References/GRCh38.primary_assembly.genome.fa -V selected.vcf.gz --window 35 --cluster 3 
--filter-name "FS" --filter "FS > 30.0" --filter-name "QD" --filter "QD < 2.0" -O selected_VF.vcf.gz
