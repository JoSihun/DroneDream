thdown_blue = [0.5, 0.35, 0.25];        % 파란색의 임계값 범위
thup_blue = [0.75, 1, 1];
thdown_red = [0.0, 40/240, 65/240];     % 빨간색 점의 임계값 범위
thup_red = [0.0, 240/240, 240/240];
thdown_purple = [0.25, 35/240, 45/240]; % 보라색 점의 임계값 범위
thup_purple = [0.3, 240/240, 240/240];

frame = imread('dot1.jpg');
src_hsv = rgb2hsv(frame);
src_h = src_hsv(:,:,1);
src_s = src_hsv(:,:,2);
src_v = src_hsv(:,:,3);
[rows, cols, channels] = size(src_hsv);

bw1 = (0 < src_h)&(src_h < 0) & (40/240 < src_s)&(src_s < 1) & (65/240 < src_v)&(src_v < 1);
bw2 = imfill(bw1,'holes');

count_pixel = 0;
center_row = 0;
center_col = 0;
for row = 1:rows
    for col = 1:cols
        if bw2(row, col) == 1
            count_pixel = count_pixel + 1;
            center_row = center_row + row;
            center_col = center_col + col;    
        end        
    end
end

subplot(2, 2, 1), imshow(frame); hold on;
plot(center_col, center_row, 'r*'); hold off;
subplot(2, 2, 3), imshow(bw1); hold on;
plot(center_col, center_row, 'r*'); hold off;
subplot(2, 2, 4), imshow(bw2); hold on;
plot(center_col, center_row, 'r*'); hold off;
%             imshow(bw1);
%             imshow(bw2);