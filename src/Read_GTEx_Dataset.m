% Read GXE Dataset


data_dir = 'C:/Users/user/Documents/GitHub/course52311/data'; 

%D = xlsread(fullfile(data_dir, 'AllSamples.rpkm.gct')); 

%D2 = tdfread(fullfile(data_dir, 'GTEx/AllSamples.rpkm.00')); 

ensemble_ids = []; 
gene_ids = []; 
Data = []; 
% Loop over chunks and read them 
for c = 1:100 
       sprintf('Read GTEx File %ld', c)
    if(c<=10)
        c_str = ['0' num2str(c-1)];
    else
        c_str = num2str(c-1); 
    end
    D = loadcellfile(fullfile(data_dir, ['GTEx/AllSamples.rpkm.' c_str])); 
    if(c == 1) % first file contains header 
        sample_ids = D(3,3:end); 
        D = D(4:end,:); 
    else
        D = D(2:end,:); 
    end
    cur_ensemble_ids = D(1:end-1,1); 
    cur_gene_ids = D(1:end-1,2);     
    ensemble_ids = [ensemble_ids' cur_ensemble_ids']'; 
    gene_ids = [gene_ids' cur_gene_ids']'; 

    cur_data = single(cell2mat(D(1:end-1,3:end))); 
    Data = [Data' cur_data']'; 
    
    save(fullfile(data_dir, 'GTEx/AllSamples.rpkm.mat'), 'Data', 'sample_ids', 'gene_ids', 'ensemble_ids'); 
end

% Get tissue for each sample 

