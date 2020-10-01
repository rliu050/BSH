if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("KEGGREST")

library("KEGGREST")
library(Biostrings)

KO_number <- c("K20038")
gene_info <- keggFind("genes", KO_number)
gene_list <- names(gene_info)
# mode(gene_list)
# [1] "character"
# str(gene_list[1])
# Named chr "uncharacterized protein LOC111685019" # check the structure
# - attr(*, "names")= chr "lcq:111685019"

for (i in 1:length(gene_list)){
  gene_seq<-keggGet(gene_list[i],"ntseq") 
  filename <- paste(gsub(":","_",c(gene_list[i])),".fa",sep="") # gsub pattern matching and replacement
  writeXStringSet(gene_seq, filename, format = "fasta")
}

```cmd try default db
makeblastdb -in bsh_genes.fa -title "BSHGENE" -dbtype nucl
for file in *.fasta; do blastn -query $file -db ../../bsh_genes.fa -evalue 0.00001 -outfmt 7 -out $file.BLASTN.tab; done
for file in *.BLASTN.tab; do echo $file >>bsh_counts.txt; grep -c "Fields" $file >>bsh_counts.txt; done
for file in *.fasta; do echo $file >>total_reads.txt; grep -c ">" $file >>total_reads.txt; done
for file in *.tab; do echo $file >> CN_layases_counts.txt; grep -c "Fields" $file >> CN_layases.txt;done
for file in *.tab; do echo $file > $file.txt; grep "Fields" -A 11 $file >> $file.txt;done
```

library("openxlsx")
library("ggplot2")
bsh <- read.xlsx("./inline-supplementary-material-4.xlsx",5)
mapping <- read.xlsx("./inline-supplementary-material-4.xlsx",4)
data_bsh <- merge(bsh, mapping,by=1)
ggplot(data_bsh,aes(x=group,y=BSH.p.nohuman))+geom_boxplot()

summary <- read.xlsx("./summary.xlsx",6)
sum_d <- summary[1:28,]
sum_r <- summary[c(1:7,29:55),]
ggplot(sum_d,aes(x=time.point, y=percentage, colour=individual, group=individual))+geom_line(size=2)+geom_point(size=4)
ggsave("diarrhea.pdf",width=7,height=4)
ggplot(sum_r,aes(x=time.point, y=percentage, colour=individual, group=individual))+geom_line(size=2)+geom_point(size=4)
ggsave("recovery.pdf",width=7,height=4)
