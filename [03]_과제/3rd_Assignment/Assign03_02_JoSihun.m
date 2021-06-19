% 중심좌표 미묘하게 안 맞음
% 수정방법1: 대각선 크로스 교차점을 이용한 중심좌표 탐색
% 수정방법2: 내부사각형 좌표값 평균을 이용한 중심좌표 탐색
% 
% test_019.png ROI까지는 잘 되나, 코너값을 못 찾음
% 수정방법1: Canny Edge 사용 후 코너값 탐색
src = imread('./datasets/test_019.png');
imshow(src);

% Flip Image
flipud_src = flipud(src);   % 상하반전
fliplr_src = fliplr(src);   % 좌우반전

% Rotate Image
rotate90_src = imrotate(src, 90, 'nearest', 'crop');        % 90도 회전
rotate180_src = imrotate(src, 180, 'nearest', 'crop');      % 180도 회전
rotate270_src = imrotate(src, 270, 'nearest', 'crop');      % 270도 회전
rotate360_src = imrotate(src, 360, 'nearest', 'crop');      % 360도 회전

% GrayScale Convert & Canny Edge
gray_src = rgb2gray(src);
canny_dst = edge(gray_src, 'Canny');

% HSV Convert
src_hsv = rgb2hsv(src);
src_hsv_h = src_hsv(:, :, 1);
src_hsv_s = src_hsv(:, :, 2);
src_hsv_v = src_hsv(:, :, 3);

% HSV Threshold Green
thdown_green = [0.25, 40/240, 80/240];
thup_green = [0.40, 240/240, 240/240];

% ImageProcessing1
dst_hsv1 = double(zeros(size(src_hsv)));
dst_hsv2 = double(zeros(size(src_hsv)));
[rows, cols, channels] = size(src_hsv);
for row = 1:rows
    for col = 1:cols
        if thdown_green(1) < src_hsv(row, col, 1) && src_hsv(row, col, 1) < thup_green(1) ...
        && thdown_green(2) < src_hsv(row, col, 2) && src_hsv(row, col, 2) < thup_green(2) ...
        && thdown_green(3) < src_hsv(row, col, 3) && src_hsv(row, col, 3) < thup_green(3)
%             dst_hsv(row, col, :) = src_hsv(row, col, :);
%             dst_hsv(row, col, :) = (thdown_green + thup_green) / 2;
            dst_hsv1(row, col, :) = [0, 0, 1];   % White
            dst_hsv2(row, col, :) = [0, 0, 0];   % Black
        else
            dst_hsv1(row, col, :) = [0, 0, 0];   % Black
            dst_hsv2(row, col, :) = [0, 0, 1];   % White
        end
    end
end

% Image Processing2
thres_dst1 = hsv2rgb(dst_hsv1);                 % 붙여넣야하는 그림 / 초록색이 White
thres_dst2 = hsv2rgb(dst_hsv2);                 % 잘라내야하는 그림 / 초록색이 Black

gray_thres_dst1 = rgb2gray(thres_dst1);         % 붙여넣야하는 그림 / 초록색이 White
gray_thres_dst2 = rgb2gray(thres_dst2);         % 잘라내야하는 그림 / 초록색이 Black
corners1 = pgonCorners(gray_thres_dst1, 4);
corners2 = pgonCorners(gray_thres_dst2, 4);

roix = [corners1(1, 2) + 5, corners1(2, 2) - 5, corners1(3, 2) - 5, corners1(4, 2) + 5];    % ROI 범위 소량 확장
roiy = [corners1(1, 1) - 5, corners1(2, 1) - 5, corners1(3, 1) + 5, corners1(4, 1) + 5];    % ROI 범위 소량 확장
roi = roipoly(thres_dst1, roix, roiy);
thres_dst = thres_dst2 .* roi;
gray_thres_dst = rgb2gray(thres_dst);
corners = pgonCorners(gray_thres_dst, 4);
p1 = corners(4, :);         % 좌상단
p2 = corners(3, :);         % 우상단
p3 = corners(1, :);         % 좌하단
p4 = corners(2, :);         % 우하단

% Result
imshow(src);
hold on;
plot(p1(2), p1(1), 'ro');   % 좌상단
plot(p2(2), p2(1), 'go');   % 우상단
plot(p3(2), p3(1), 'bo');   % 좌하단
plot(p4(2), p4(1), 'yo');   % 우하단
polyin = polyshape(corners(:, 2), corners(:, 1));
[x, y] = centroid(polyin);
plot(x, y, 'r*');   % 중심좌표
hold off;

% dst_bw = rgb2gray(thres_dst1);
% corners = pgonCorners(dst_bw, 4);
% imshow(dst_bw);
% hold on;
% % plot(corners(:, 2), corners(:, 1), 'yo', 'MarkerFaceColor', 'r', 'MarkerSize', 12, 'LineWidth', 2);
% plot(corners(:, 2), corners(:, 1), 'r*');
% hold off;
% p1 = corners(4, :);
% p2 = corners(3, :);
% p3 = corners(1, :);
% p4 = corners(2, :);
% % patch(corners(:, 2), corners(:, 1),'green')
