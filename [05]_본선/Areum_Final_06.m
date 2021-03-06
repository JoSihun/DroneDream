clear()
% HSV Threshold Blue
thdown_blue = [0.55, 0.43, 0.43];
thup_blue = [0.75, 1, 1];
% HSV Threshold Red
% thdown_red1 = [0, 0.25, 0.25];
% thup_red1 = [0.02, 1, 1];
% thdown_red2 = [0.975, 0.25, 0.25];
% thup_red2 = [1, 1, 1];
thdown_red1 = [0, 0.65, 0.25];
thup_red1 = [0.025, 1, 1];
thdown_red2 = [0.975, 0.65, 0.25];
thup_red2 = [1, 1, 1];
% HSV Threshold Purple
thdown_purple = [0.725, 0.25, 0.25];
thup_purple = [0.85, 1, 1];

frame = imread('81.png');
src_hsv = rgb2hsv(frame);
src_h = src_hsv(:, :, 1);
src_s = src_hsv(:, :, 2);
src_v = src_hsv(:, :, 3);
% Image Preprocessing
bw_blue = (thdown_blue(1) < src_h) & (src_h < thup_blue(1)) & (thdown_blue(2) < src_s)&(src_s < thup_blue(2));
% bw_blue = (thdown_blue(1) < src_h) & (src_h < thup_blue(2)) & (thdown_blue(2) < src_s)&(src_s < thup_blue(2)) & (thdown_blue(3) < src_v) & (src_v < thup_blue(3));
% bw_red = (thdown_red1(1) < src_h & src_h < thup_red1(1)) ...
%        + (thdown_red2(1) < src_h & src_h < thup_red2(1));
% bw_purple = (thdown_purple(1) < src_h) & (src_h < thup_purple(1));

bw_red = ((thdown_red1(1) < src_h)&(src_h < thup_red1(1)) & (thdown_red1(2) < src_s)&(src_s < thup_red1(2))) ...
        | ((thdown_red2(1) < src_h)&(src_h < thup_red2(1)) & (thdown_red2(2) < src_s)&(src_s < thup_red2(2))); 
bw_purple = (thdown_purple(1) < src_h)&(src_h < thup_purple(1)) & (thdown_purple(2) < src_s)&(src_s < thup_purple(2));

subplot(2, 2, 1), imshow(frame);
subplot(2, 2, 2), imshow(bw_blue);
subplot(2, 2, 3), imshow(bw_red);
subplot(2, 2, 4), imshow(bw_purple);
