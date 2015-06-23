require(data.table)
source("ForOr/dataPreparation.R")
annot<-data.frame(fread("GTEx_Data_2014-01-17_Annotations_SampleAttributesDS.txt"))
express<-data.frame(fread("GTEx_Analysis_2014-01-17_RNA-seq_RNA-SeQCv1.1.8_gene_rpkm.gct"))
## Change . to - to match column names and annotation file
names(express)<-gsub("\\.","-",colnames(express))

expressLung<-makeTissueExpressionSet(express,annot$SAMPID,annot$SMTSD,"Lung")
expressThyroid<-makeTissueExpressionSet(express,annot$SAMPID,annot$SMTSD,"Thyroid")

intersectionTable<-intersectExpressionTablesOnSubjects(expressLung,expressThyroid)  
expressLungMatched<-data.matrix(expressLung[,intersectionTable[,1]])
expressThyroidMatched<-data.matrix(expressThyroid[,intersectionTable[,2]])
