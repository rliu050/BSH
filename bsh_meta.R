
library("keggrest")
library(Biostrings)
for (i in 1:length(bsh_vector)){
  test.seq<-keggGet(bsh_vector[i],"ntseq") # got the gene list from KEGG_enzyme3.5.1.24
  name <- gsub(":","_",c(bsh_vector[i]))
  writeXStringSet(test.seq, name, format = "fasta")
}


