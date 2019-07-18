
library("keggrest")
library(Biostrings)
for (i in 1:length(bsh_vector)){
  test.seq<-keggGet(bsh_vector[i],"ntseq") # got the gene list from KEGG_enzyme3.5.1.24
  name <- paste(gsub(":","_",c(bsh_vector[i])),".fa",sep="")
  writeXStringSet(test.seq, name, format = "fasta")
}

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
