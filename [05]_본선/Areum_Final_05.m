clear()
% HSV Threshold Blue
thdown_blue = [0.5, 0.35, 0.25];        % 파란색의 임계값 범위
thup_blue = [0.75, 1, 1];             
red = [255/255, 0, 0];
purple = [112/255, 48/255, 160/255];
th_red = rgb2hsv(red);
th_purple = rgb2hsv(purple);

droneObj = ryze();
cameraObj = camera(droneObj);
% takeoff(droneObj);
% frame = imread('dot1.jpg');
while 1
    % HSV Convert
    frame = snapshot(cameraObj);
    src_hsv = rgb2hsv(frame);
    src_h = src_hsv(:,:,1);
    src_s = src_hsv(:,:,2);
    src_v = src_hsv(:,:,3);
    [rows, cols, channels] = size(src_hsv);
    
    % Image Preprocessing
%     bw_red = (th_red(1) == src_h) & (th_red(2) == src_s) & (th_red(3) == src_v);
%     bw_purple = (th_purple(1) == src_h) & (th_purple(2) == src_s) & (th_purple(3) == src_v);
      bw_red = (th_red(1) < src_h)&(src_h < th_red(1) + 0.3) & (th_red(2) - 0.5 < src_s)&(src_s < th_red(2)) & (th_red(3) - 0.5 < src_v)&(src_v < th_red(3));
      bw_purple = (th_purple(1) - 0.5 < src_h)&(src_h < th_purple(1) + 0.2) & (th_purple(2) - 0.4 < src_s)&(src_s < th_purple(2) + 0.3) & (th_purple(3) - 0.4 < src_v)&(src_v < th_purple(3) + 0.3);
    
%     moveforward(droneObj, 'distacne', 1.75);
%     while(1)
%         frame = snapshot(cameraObj);
        subplot(1, 3, 1), imshow(frame);
        subplot(1, 3, 2), imshow(bw_red);
        subplot(1, 3, 3), imshow(bw_purple);
        
%     end
end