% 중심좌표탐색
% 방법1: 내부사각형 좌표값 평균을 이용한 중심좌표 탐색
% 방법2: 대각선 크로스 교차점을 이용한 중심좌표 탐색 (현재적용중인코드)
% 원리: 내외부 사각형을 반전(ROI사용)시킨 뒤, Canny Edge 적용 후 코너값 탐색

% Image Read
src = imread('./datasets/test_019.png');
imshow(src);

% HSV Convert
src_hsv = rgb2hsv(src);

% HSV Threshold Green
thdown_green = [0.25, 40/240, 80/240];
thup_green = [0.40, 240/240, 240/240];

[rows, cols, channels] = size(src_hsv);
dst_hsv1 = double(zeros(size(src_hsv)));
dst_hsv2 = double(zeros(size(src_hsv)));
dst_h = dst_hsv1(:, :, 1);
dst_s = dst_hsv1(:, :, 2);
dst_v = dst_hsv1(:, :, 3);

cnt_rows=0; cnt_cols=0;
sum_rows=0; sum_cols=0;

for row = 1:rows
    for col = 1:cols
        if thdown_green(1) < src_hsv(row, col, 1) && src_hsv(row, col, 1) < thup_green(1) ...
                && thdown_green(2) < src_hsv(row, col, 2) && src_hsv(row, col, 2) < thup_green(2) ...
                && thdown_green(3) < src_hsv(row, col, 3) && src_hsv(row, col, 3) < thup_green(3)
            dst_hsv1(row, col, :) = [0, 0, 1];
            dst_hsv2(row, col, :) = [0, 0, 0];
        else
            dst_hsv1(row, col, :) = [0, 0, 0];
            dst_hsv2(row, col, :) = [0, 0, 1];
        end
    end
end

dst_rgb1 = hsv2rgb(dst_hsv1);
dst_rgb2 = hsv2rgb(dst_hsv2);

dst_gray1 = rgb2gray(dst_rgb1);
corners1 = pgonCorners(dst_gray1, 4);

% p1 = corners(4, :); 좌상단
% p2 = corners(3, :); 우상단
% p3 = corners(1, :); 좌하단
% p4 = corners(2, :); 우하단

roi_x = [corners1(1, 2) + 5, corners1(2, 2) - 5, corners1(3, 2) - 5, corners1(4, 2) + 5];
roi_y = [corners1(1, 1) - 5, corners1(2, 1) - 5, corners1(3, 1) + 5, corners1(4, 1) + 5];
roi = roipoly(dst_gray1, roi_x, roi_y);


dst_img = dst_rgb2 .* roi;        %점곱으로 2차배열이미지 곱해서 합쳐주기
dst_gray = rgb2gray(dst_img);
dst_edge = edge(dst_gray, 'Canny');  %엣지검출로 모서리 확실하게 만들기

imshow(dst_edge);

% figure();
% imshow(dst_rgb1); hold on;
% plot(corners(:, 2), corners(:, 1), 'ro');
% figure();
% imshow(dst_rgb2);
