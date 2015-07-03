##ENTER YOUR MASTER DIRECTORY
file.path = "C:/Users/Avishay/Desktop/course52311/data/GTEx/"

AllSamples.rpkm_3D =readRDS(paste0(file.path,"AllSamples_rpkm_3D"))
AllSamples.rpkm_3D_values =readRDS(paste0(file.path,"AllSamples_rpkm_3D_values"))

ExpressionData_3D_Array <- array(rep(0, AllSamples.rpkm_3D$num.tissues*AllSamples.rpkm_3D$num.individuals*AllSamples.rpkm_3D$num.genes), c(AllSamples.rpkm_3D$num.tissues, AllSamples.rpkm_3D$num.individuals, AllSamples.rpkm_3D$num.genes));  
ExpressionData_3D_Array[AllSamples.rpkm_3D$inds.3d] = AllSamples.rpkm_3D_values$vals.3d



# file.name = paste0(file.path,"AllSamples.rpkm_3D",
#                    ".mat")
# AllSamples_rpkm_3D <- readMat(file.name) 
# 
# file.name_values = paste0(file.path,"AllSamples.rpkm_3D_values",
#                           ".mat")
# AllSamples.rpkm_3D_values <- readMat(file.name_values) 
# 
# ExpressionData_3D_Array <- array(rep(0, AllSamples.rpkm_3D$num.tissues*AllSamples.rpkm_3D$num.individuals*AllSamples.rpkm_3D$num.genes), c(AllSamples.rpkm_3D$num.tissues, AllSamples.rpkm_3D$num.individuals, AllSamples.rpkm_3D$num.genes));  
# ExpressionData_3D_Array[AllSamples.rpkm_3D$inds.3d] = AllSamples.rpkm_3D_values$vals.3d
