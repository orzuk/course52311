% Read Video Dataset

data_dir = 'C:/Users/user/Documents/GitHub/course52311/data'; 

video_file = 'Video/Charlie Chaplin - The Lions Cage.mp4'

if(~exist(fullfile(data_dir, strrep(video_file, 'mp4', 'mat')), 'file')) % read an .mp4 file into multidimensional Matlab array
    V = VideoReader(fullfile(data_dir, video_file));
    
    frame_width = V.Width;
    frame_length = V.Height;
    num_frames = V.numberOfFrames;
    VideoData = V.read;
    
    VideoDataIntensity = single(VideoData(:,:,1,:))+single(VideoData(:,:,2,:))+single(VideoData(:,:,3,:)); clear VideoData; 
    VideoDataIntensity = reshape(VideoDataIntensity, [frame_length, frame_width, num_frames]);

    % Split data into bins
    num_frame_bins = 103; bin_size = ceil(num_frames/num_frame_bins)
    for i=1:num_frame_bins
        sprintf('Save frames in bin %ld', i) 
        cur_frame_inds = ((i-1)*bin_size+1):min(i*bin_size, num_frames);
        VideoDataIntensity_3D = VideoDataIntensity(:,:,cur_frame_inds); 
        save(fullfile(data_dir, strrep(video_file, '.mp4', ['_' num2str(i) '.mat'])), ...
            'VideoDataIntensity_3D', 'num_frames', 'frame_width', 'frame_length');    
        % save also in excel format: 
        VideoData_2D = reshape(VideoDataIntensity_3D, [frame_length, frame_width*length(cur_frame_inds)]);
        xlswrite(fullfile(data_dir, strrep(video_file, '.mp4', ['_' num2str(i) '.xlsx'])), VideoData_2D'); % write to tab-delimited format 
    end

    
    
    
else
    load(fullfile(data_dir, strrep(video_file, 'mp4', 'mat')));  % load multi-dimensional array containing video
end

%% CC = VideoReader(fullfile(data_dir, 'Video/CC_1916_10_02_ThePawnshop_512kb.mp4')); 


