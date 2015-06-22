##Here enter the path of the mat files
file.path = "C:/Users/Avishay/Desktop/course52311/data/Video/"

num_image = 103 #number of chuncks

#For each chunk, read the mat file and save as RDS file.
for(i in 1:num_image){
  print(i)
  file.name = paste0(file.path,"Charlie Chaplin - The Lions Cage_",toString(i),
                     ".mat") 
  data <- readMat(file.name) 
  saveRDS(data,paste0(file.path,"Charlie Chaplin - The Lions Cage_",toString(i)))
}


#read the first RDS file into X
X = readRDS("C:/Users/Avishay/Desktop/course52311/data/Video/Charlie Chaplin - The Lions Cage_1")



file.name = "C:/Users/Avishay/Documents/MATLAB/course52311/data/Video/Charlie Chaplin - The Lions Cage_1.mat"
data <- readMat(file.name)
data = readRDS("C:/Users/Avishay/Desktop/course52311/data/Video/Charlie_Chaplin_The_Lions_Cage_1R")
