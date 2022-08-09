### Merge VCFs & Indexing ###

bcftools-1.9/bcftools merge -l list-of-selected-VCFs.txt -Oz -o selected.vcf.gz 

tabix -p vcf selected.vcf.gz

### Filteration of called SNPs ###

gatk-4.2.3.0/gatk VariantFiltration -R ../References/GRCh38.primary_assembly.genome.fa -V selected.vcf.gz --window 35 --cluster 3 
--filter-name "FS" --filter "FS > 30.0" --filter-name "QD" --filter "QD < 2.0" -O selected_VF.vcf.gz
