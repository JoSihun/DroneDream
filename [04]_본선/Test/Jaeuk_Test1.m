% droneObj = ryze()
% cameraObj = camera(droneObj)
% takeoff(droneObj)
% moveup(droneObj, 'Distance', 0.8)
% moveforward(droneObj, 'Distance', 2)

FILENAME = "test.png";
src_rgb = imread(FILENAME);         % src_gray = rgb2gray(src_rgb);
src_hsv = rgb2hsv(src_rgb);         % HSV 3차원 배열
src_h = src_hsv(:, :, 1);           % Hue 채널
src_s = src_hsv(:, :, 2);           % Saturation 채널
src_v = src_hsv(:, :, 3);           % Value 채널

red_down = [1,0,0];
red_up = [0.05,1,1];
green_down = [0.275];
green_up = [0.325];
blue_down = [0.575,0,0];
blue_up = [0.625,1,1];

[rows, cols, channels] = size(src_hsv);
dst_hsv = double(zeros(size(src_hsv)));

dst_h = dst_hsv(:, :, 1);
dst_s = dst_hsv(:, :, 2);
dst_v = dst_hsv(:, :, 3);




















while 1
     frame = snapshot(cam);
     subplot(2,1,1), imshow(frame);
     pause(2);
     hsv = rgb2hsv(frame);
     h = hsv(:,:,1);
     detect_red = (h>1)+(h<0.05);
     if sum(detect_red, 'all') >= 17000
          moveforward(droneObj, 'Distance', 1);
          turn(droneObj, deg2rad(270));
          break
     end
end
moveforward(droneObj, 'Distance', 2)
while 1
     frame = snapshot(cam);
     subplot(2,1,1), imshow(frame);
     pause(2);
     hsv = rgb2hsv(frame);
     h = hsv(:,:,1);
     detect_blue = (0.575<h)&(h<0.625);
     if sum(detect_blue, 'all') >= 15000
          moveforward(droneObj, 'Distance', 1);
          land(droneObj);
          break
     end
end
takeoff(droneObj)
moveup(droneObj, 'Distance', 0.8)
turn(droneObj, deg2rad(270))
while 1
     frame = snapshot(cam);
     subplot(2,1,1), imshow(frame);
     pause(2);
     hsv = rgb2hsv(frame);
     h = hsv(:,:,1);
     detect_red = (h>1)+(h<0.05);
     if sum(detect_red, 'all') >= 17000
          moveforward(droneObj, 'Distance', 1);
          land(droneObj);
          break       
     end
end