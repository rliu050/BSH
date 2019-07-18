# get all the gene list and make a database

makeblastdb -in bsh_genes.fa -title "BSHGENE" -dbtype nucl

# get the sequencing files that you want

dos2unix file_selected.txt #  terminate lines for windows is \n\r, for linux is \n, need to convert format or just remove \r
for file in $(cat file_selected.txt); do mv "$file" ./file_selected; done
for file in *.gz; do seqtk seq -a $file > $file.fasta; done
for file in *.fasta; do blastn -query $file -db ../../bsh_genes.fa -evalue 0.00001 -outfmt 7 -out $file.BLASTN.tab; done
for file in *.BLASTN.tab; do echo $file >>bsh_counts.txt; grep -c "Fields" $file >>bsh_counts.txt; done
for file in *.fasta; do echo $file >>total_reads.txt; grep -c ">" $file >>total_reads.txt; done

# filter out human genomic DNA

makeblastdb -in GCF_000001405.38_GRCh38.p12_genomic.fna -title "human" -dbtype nucl
for file in *.fasta; do blastn -query $file -db ../../GCF_000001405.38_GRCh38.p12_genomic.fna -evalue 0.00001 -outfmt 7 -out $file.human.BLASTN.tab; done
# it takes too long
# switch to hisat2

for file in *.fasta; do echo $file; hisat2 -f -x ../../hsa -U $file -S $file.bam; done

# need to remove all vc_bsh

makeblastdb -in bsh_gene_no_vc.fa -title "BSHGENENOVC" -dbtype nucl
for file in *.fasta; do blastn -query $file -db ../../bsh_gene_no_vc.fa -evalue 0.00001 -outfmt 7 -out $file.novc.BLASTN.tab; done
for file in *.BLASTN.tab; do echo $file >>bsh_no_vc_counts.txt; grep -c "Fields" $file >>bsh_no_vc_counts.txt; done

# also need to filter out V. cholerae reads

hisat2-build
for file in *.fasta; do echo $file; hisat2 -f -x ../../vcholerae -U $file -S $file.bam; done


