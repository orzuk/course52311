% Read GXE Dataset

data_dir = 'C:/Users/user/Documents/GitHub/course52311/data';

%D = xlsread(fullfile(data_dir, 'AllSamples.rpkm.gct'));
%D2 = tdfread(fullfile(data_dir, 'GTEx/AllSamples.rpkm.00'));
num_files = 100; % split GTEx data to files
convert_to_mat_files = 0; % if 1 - convery raw data to .mat files
load_data = 1;

data_annotations_file = ...
    fullfile(data_dir, 'GTEx/GTEx_Analysis_Annotations_Sample_DS__Pilot_V3.txt'); % get annotations

if(~load_data)
    if(convert_to_mat_files)
        annotations_s = loadcellfile(data_annotations_file, [], 9); % read (tab-delimited file)
        annotations_sample_ids = annotations_s(2:end,1)
        annotations_tissue_ids = annotations_s(2:end,6)
        annotations_tissue_detailed_ids = annotations_s(2:end,7)
        
        num_annotations_samples = length(annotations_sample_ids);
        for i=1:num_annotations_samples
            if(strncmp('GTEX', str2word('-', annotations_sample_ids{i}, 1), 4))
                annotations_individual_ids{i} = str2word('-', annotations_sample_ids{i}, 2);
            else
                
            end
        end
        
        
        % Loop over chunks and read them
        for c = 1:num_files
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
                
                % Intersect annotations file with data file labels
                [common_sample_ids, I, J] = intersect(sample_ids, annotations_sample_ids);
                I_inv = inv_perm(I);
                common_tissue_ids = annotations_tissue_ids(J);
                common_tissue_detailed_ids = annotations_tissue_detailed_ids(J);
                common_individual_ids = annotations_individual_ids(J);
                
                tissue_ids = common_tissue_ids(I_inv);
                tissue_detailed_ids = common_tissue_detailed_ids (I_inv);
                individual_ids = common_individual_ids(I_inv);
                
                
                ensemble_ids = [];
                gene_ids = [];
                Data = [];
                
                new_D = [vec2column(sample_ids) vec2column(individual_ids) tissue_ids tissue_detailed_ids]
                new_D = [ [cell(4,2) new_D']' D']';
                new_D2 = num2str_cell(new_D, 2);
                new_D2 = new_D2';
                
                savecellfile(new_D2, fullfile(data_dir, ['GTEx/AllSamples.rpkm.' c_str '.txt']));
                xlswrite(fullfile(data_dir, ['GTEx/AllSamples.rpkm.' c_str '.xlsx']), new_D2)
                
                
                
                
            else
                D = D(2:end,:);
            end
            cur_ensemble_ids = D(1:end-1,1);
            cur_gene_ids = D(1:end-1,2);
            ensemble_ids = [ensemble_ids' cur_ensemble_ids']';
            gene_ids = [gene_ids' cur_gene_ids']';
            
            cur_data = single(cell2mat(D(1:end-1,3:end)));
            Data = [Data' cur_data']';
            
            save(fullfile(data_dir, 'GTEx/AllSamples.rpkm.mat'), ...
                'Data', 'sample_ids', 'gene_ids', 'ensemble_ids', ...
                'tissue_ids', 'tissue_detailed_ids', 'individual_ids');
        end
    else % here read .mat files and build a 3D array representing samples
        C = load(fullfile(data_dir, 'GTEx/AllSamples.rpkm.mat'));
        
        [tissue_ids_unique tissue_ids_unique_inds] = unique_with_inds(tissue_ids)
        [individual_ids_unique individual_ids_unique_inds] = unique_with_inds(individual_ids)
        num_samples = length(C.sample_ids);
        num_genes = length(C.gene_ids);
        num_tissues = length(tissue_ids_unique);
        num_individuals = length(individual_ids_unique);
        sparsity = num_samples / (num_individuals*num_tissues);
        tissue_by_individual_matrix = zeros(num_tissues, num_individuals);
        for t=1:num_tissues
            for i=1:num_individuals
                if(~isempty(intersect(tissue_ids_unique_inds{t}, individual_ids_unique_inds{i})))
                    tissue_by_individual_matrix(t,i)=1;
                end
            end
        end
        figure; imagesc_with_labels(tissue_by_individual_matrix, [], tissue_ids_unique'); % colorbar;
        xlabel('Individual'); ylabel('Tissue'); title(['Availability of GTEx Data: Brown - available (' ...
            num2str(sparsity*100,3) '%), Blue - non-available']);
        my_saveas(gcf, fullfile(data_dir, 'GTEx/IndividualByTissueDataAvailability'), {'epsc', 'pdf', 'jpg'});
        
        % create a 3D array with all data
        ExpressionData_3D_Array = zeros(num_tissues, num_individuals, num_genes, 'single');
        for t=1:num_tissues
            run_tissue = t
            for i=1:num_individuals
                if(tissue_by_individual_matrix(t,i))
                    cur_ind = intersect(tissue_ids_unique_inds{t}, individual_ids_unique_inds{i});
                    ExpressionData_3D_Array(t,i,:) = C.Data(:,cur_ind(1)); % choose first in case of replicate
                end
            end
        end
        %    save(fullfile(data_dir, 'GTEx/AllSamples.rpkm_3D.mat'), ...
        %        'ExpressionData_3D_Array', 'tissue_by_individual_matrix', ...
        %        'gene_ids', 'tissue_ids', 'individual_ids');
        inds_3d = find(ExpressionData_3D_Array);
        vals_3d = ExpressionData_3D_Array(inds_3d); 
        save(fullfile(data_dir, 'GTEx/AllSamples.rpkm_3D.mat'), ...
            'inds_3d', 'vals_3d', 'tissue_by_individual_matrix', ...
            'num_tissues', 'num_individuals', 'num_genes', ...
            'gene_ids', 'tissue_ids', 'individual_ids');
    end
    
    
else % Here load data:
    load(fullfile(data_dir, 'GTEx/AllSamples.rpkm_3D.mat'));
    ExpressionData_3D_Array = zeros(num_tissues, num_individuals, num_genes, 'single');
    ExpressionData_3D_Array(inds_3d) = vals_3d;
end