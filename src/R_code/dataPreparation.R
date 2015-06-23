
#### A function that takes the global expression matrix "expressionData", a vector of sample names "sampleList" that corresponds to the column names of expressionData
#### a vector of tissue names "tissueList" that links sample names to tissues, and optional arguments for filtering based on expression and IQR.
makeTissueExpressionSet<-function(expressionData,sampleList,tissueList,tissue,expCutoff=NULL,IQRcutoff=NULL)
{
  samplesTissue<- sampleList[tissueList==tissue]
  if(length(samplesTissue)==0) stop("select tissue doesn't exist in annotation table")
  curTissue<- expressionData[,colnames(expressionData)%in%samplesTissue]
  if(is.numeric(expCutoff))curTissue<- curTissue[apply(curTissue,1,function(x)!(sum(x<expCutoff)>(length(x)*0.1))),]
  if(is.numeric(IQRcutoff)) 
    {
    interQuantTissue<-apply(curTissue,1,IQR)
    curTissue<- curTissue[order(interQuantTissue,decreasing=T)[1:min(IQRcutoff,nrow(curTissue))],]
    }
  return(curTissue)
}

### A function that accepts two expression sets and intersects them choosing only shared individuals
intersectExpressionTablesOnSubjects<-function(expressionData1,expressionData2)
{
  subject1<-getSubjectFromExpressionData(expressionData1)
  subject2<-getSubjectFromExpressionData(expressionData2)
  inter<-intersect(subject1,subject2)
  cbind(match(inter,subject1),match(inter,subject2))
}

### a function to get sample names from an expressionData set
getSubjectFromExpressionData<-function(expressionData)
{
  gsub("-[0-9]+.*","",colnames(expressionData))
}
