### Preprocessing measures using picard-tools ###

# 1a. BuildBamIndex-picard

java -jar picard.jar BuildBamIndex I=${sample}.fastq.gzAligned.sortedByCoord.out.bam

# 2a. ReorderSam-picard

java -jar picard.jar ReorderSam INPUT=${sample}.fastq.gzAligned.sortedByCoord.out.bam OUTPUT=${sample}_reordered.bam 
SEQUENCE_DICTIONARY=../References/GRCh38.primary_assembly.genome.dict CREATE_INDEX=true

# 3a. AddOrReplaceReadGroups-picard

java -jar picard.jar AddOrReplaceReadGroups INPUT=${sample}_reordered.bam OUTPUT=${sample}_AddReplaceGroup.bam 
SORT_ORDER=coordinate CREATE_INDEX=true RGID=${sample} RGSM=${sample} RGLB=Fragment RGPL=platform RGCN=center RGPU=${sample}

# 4a. MarkDuplicates-picard

java -Xmx32G -jar picard.jar MarkDuplicates INPUT=${sample}_AddReplaceGroup.bam OUTPUT=${sample}_markduplicate.bam 
CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT METRICS_FILE=${sample}.metrics
