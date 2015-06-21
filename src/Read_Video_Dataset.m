% Read Video Dataset


data_dir = 'C:/Users/user/Documents/GitHub/course52311/data'; 

V = VideoReader(fullfile(data_dir, 'Video/Short video clip-nature.mp4')); 

frame_width = V.Width;
frame_length = V.Height; 
num_frames = V.numberOfFrames;
VideoData = V.read; 
save(fullfile(data_dir, 'Video/Short video clip-nature.mp4'), 'VideoData', 'num_frames', 'frame_width', 'frame_length'); 

num_pixel 

CC = VideoReader(fullfile(data_dir, 'Video/CC_1916_10_02_ThePawnshop_512kb.mp4')); 


