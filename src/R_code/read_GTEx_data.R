##ENTER YOUR MASTER DIRECTORY
file.path = "C:/Users/Avishay/Desktop/course52311/data/GTEx/"

file.name = paste0(file.path,"AllSamples.rpkm_3D",
                   ".mat")
AllSamples.rpkm_3D <- readMat(file.name) 

file.name_values = paste0(file.path,"AllSamples.rpkm_3D_values",
                   ".mat")
AllSamples.rpkm_3D_values <- readMat(file.name_values) 

ExpressionData_3D_Array <- array(rep(0, AllSamples.rpkm_3D$num.tissues*AllSamples.rpkm_3D$num.individuals*AllSamples.rpkm_3D$num.genes), c(AllSamples.rpkm_3D$num.tissues, AllSamples.rpkm_3D$num.individuals, AllSamples.rpkm_3D$num.genes));  
ExpressionData_3D_Array[data$inds.3d] = AllSamples.rpkm_3D_values$vals.3d