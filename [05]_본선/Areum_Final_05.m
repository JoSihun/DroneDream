clear()
% HSV Threshold Blue
thdown_blue = [0.5, 0.35, 0.25];        % 파란색의 임계값 범위
thup_blue = [0.75, 1, 1];             
red = rgb2hsv([255/255, 0, 0]);                 % [0, 1, 1]
purple = rgb2hsv([112/255, 48/255, 160/255]);   % [0.76, 0.7, 0.6]
thdown_red = [red(1) + 0.1, red(2) - 0.8, red(3) - 0.8];
thup_red = [red(1) + 0.9, red(2) - 0.3, red(3) - 0.3];
% th_red = [red(1) + 0.2, red(2) -0.5, red(3) -0.5];
thdown_purple = [purple(1) - 0.125, purple(2) - 0.4, 0.25];
thup_purple = [purple(1) + 0.125, purple(2) + 0.3, 1];

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
%       bw_red = (th_red(1) > src_h) & (th_red(2) < src_s) & (th_red(3) < src_v);
      bw_red = ((thdown_red(1) > src_h)+(src_h > thup_red(1))) & ((thdown_red(2) > src_s)+(src_s > thup_red(2))) & ((thdown_red(3) > src_v)+(src_v > thup_red(3)));
      bw_purple = (thdown_purple(1) < src_h)&(src_h < thup_purple(1)) & (thdown_purple(2) < src_s)&(src_s < thup_purple(2)) & (thdown_purple(3) < src_v)&(src_v < thup_purple(3));
    
%     moveforward(droneObj, 'distacne', 1.75);
%     while(1)
%         frame = snapshot(cameraObj);
        subplot(1, 3, 1), imshow(frame);
        subplot(1, 3, 2), imshow(bw_red);
        subplot(1, 3, 3), imshow(bw_purple);
        
%     end
end