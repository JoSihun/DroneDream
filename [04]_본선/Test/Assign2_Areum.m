FILENAME = "test2.png";
src_rgb = imread(FILENAME);         % src_gray = rgb2gray(src_rgb);
src_hsv = rgb2hsv(src_rgb);         % HSV 3차원 배열
src_h = src_hsv(:, :, 1);           % Hue 채널
src_s = src_hsv(:, :, 2);           % Saturation 채널
src_v = src_hsv(:, :, 3);           % Value 채널

lower_red = [0, 0, 0];                   % 빨간색 범위값 정규화
upper_red = [0.05, 1, 1];                % 빨간색 범위값 정규화
lower_green = [0.25, 40/240, 80/240];             % 초록색 범위값 정규화
upper_green = [0.4, 240/240, 240/240];             % 초록색 범위값 정규화
lower_blue = [0.575, 0, 0];              % 파란색 범위값 정규화
upper_blue = [0.625, 1, 1];              % 파란색 범위값 정규화

[rows, cols, channels] = size(src_hsv);
dst_hsv = double(zeros(size(src_hsv)));
dst_h = dst_hsv(:, :, 1);
dst_s = dst_hsv(:, :, 2);
dst_v = dst_hsv(:, :, 3);

% Hue% Saturation % Value
row_array = [];
col_array = [];

min_row = rows;
min_col = cols;
max_row = 1;
max_col = 1;
for row = 1:rows
    for col = 1:cols
        if lower_green(1) < src_hsv(row, col, 1) && src_hsv(row, col, 1) < upper_green(1) ...
                && lower_green(2) < src_hsv(row, col, 2) && src_hsv(row, col, 2) < upper_green(2) ...
                && lower_green(3) < src_hsv(row, col, 3) && src_hsv(row, col, 3) < upper_green(3)
            dst_hsv(row, col, :) = src_hsv(row, col, :);
            if row < min_row
                min_row = row;
            end
            if col < min_col
                min_col = col;
            end
            if row > max_row
                max_row = row;
            end
            if col > max_col
                max_col = col;
            end
        end
    end
end

dst_rgb = hsv2rgb(dst_hsv);
% dst_rgb(min_row: min_row+10, min_col:min_col+10, :) = 255;
% dst_rgb(max_row: max_row+10, max_col:max_col+10, :) = 255;

% imshow(dst_rgb)

gray = rgb2gray(dst_rgb);
sobel_image = edge(gray,'sobel');
imshow(sobel_image)

location = detectHarrisFeatures(sobel_image);
strongest = selectStrongest(location, 10);
% points = cornerPoints(strongest);
hold on
plot(strongest)

% 
% [i,j] = find(img>max(img(;))/2);
% ij=[i,j];
% 
% [~,idx] = min(ij*[1 1;-1 -1;1 -1;-1 1].');
% 
% corners=ij(idx,:)

