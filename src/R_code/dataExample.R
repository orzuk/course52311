# Read GTEx Data (from Eyal Ben David)
setwd('C:/Users/user/Documents/GitHub/course52311/src/R_code')
require(data.table)  # install.packages('data.table')
source("dataPreparation.R")
# full-data # annot<-data.frame(fread("GTEx_Data_2014-01-17_Annotations_SampleAttributesDS.txt"))
annot<-data.frame(fread("../../data/GTEx/GTEx_Analysis_Annotations_Sample_DS__Pilot_V3.txt"))
# express<-data.frame(fread("GTEx_Analysis_2014-01-17_RNA-seq_RNA-SeQCv1.1.8_gene_rpkm.gct"))
express<-data.frame(fread("../../data/GTEx/AllSamples.rpkm.gct"))

## Change . to - to match column names and annotation file
names(express)<-gsub("\\.","-",colnames(express))

tissue_ids <- annot$SMTS
unique_tissues <- unique(annot$SMTS)
num_tissues <- length(unique_tissues)


express_dim <- dim(express)

individual_ids <- getSubjectFromExpressionData(express[,3:express_dim[2]])
unique_individuals = unique(individual_ids)

gene_ids <- express[,2]
ensemble_ids <- express[,1] # these are unique identifiers for genes
num_genes <- length(gene_ids)


# Examples for extracting expression for specific tissues: 
#expressLung<-makeTissueExpressionSet(express,annot$SAMPID,annot$SMTSD,"Lung")
#expressThyroid<-makeTissueExpressionSet(express,annot$SAMPID,annot$SMTSD,"Thyroid")
#
#intersectionTable<-intersectExpressionTablesOnSubjects(expressLung,expressThyroid)  
#expressLungMatched<-data.matrix(expressLung[,intersectionTable[,1]])
#expressThyroidMatched<-data.matrix(expressThyroid[,intersectionTable[,2]])
