% droneObj = ryze()
% cameraObj = camera(droneObj)
% 
% takeoff(droneObj)
% moveup(droneObj, 'Distance', 0.8)
% moveforward(droneObj, 'Distance', 2)

% HSV: 인간의 시각적 지각요소를 기반으로, 원통형 좌표계에서 색상을 표시하는 모델
% Hue(색조): Red, Yellow, Green, Cyan, Blue, Magenta를 주요색조로하는 인접한 색조간의 선형조합(=연속적인 색조)
% Saturation(채도): 해당 색조의 강도(짙고 옅음)
% Value(명도): 빛의 에너지 강도에 따라 감각적으로 느끼는 "밝기"

FILENAME = "test.png";
src_rgb = imread(FILENAME);         % src_gray = rgb2gray(src_rgb);
src_hsv = rgb2hsv(src_rgb);
src_h = src_hsv(:, :, 1);           % Hue 채널
src_s = src_hsv(:, :, 2);           % Saturation 채널
src_v = src_hsv(:, :, 3);           % Value 채널

lower_red = [0, 0, 0] / 255;            % 빨간색 범위값 정규화
upper_red = [25, 255, 255] / 255;       % 빨간색 범위값 정규화
lower_red = [255, 0, 0] / 255;          % 빨간색 범위값 정규화
upper_red = [255, 255, 255] / 255;      % 빨간색 범위값 정규화

lower_blue = [146, 0, 0] / 255;         % 파란색 범위값 정규화
upper_blue = [160, 255, 255] / 255;     % 파란색 범위값 정규화
lower_blue = [70, 0, 0] / 255;          % 파란색 범위값 정규화
upper_blue = [82, 255, 255] / 255;      % 파란색 범위값 정규화

lower_green = [70, 0, 0] / 255;         % 초록색 범위값 정규화
upper_green = [82, 255, 255] / 255;     % 초록색 범위값 정규화

[rows, cols, channels] = size(src_hsv);
dst_hsv = double(zeros(size(src_hsv)));
dst_h = dst_hsv(:, :, 1);
dst_s = dst_hsv(:, :, 2);
dst_v = dst_hsv(:, :, 3);

% Hue 
for row = 1:rows
    for col = 1:cols
        if lower_blue(1) < src_hsv(row, col, 1) && src_hsv(row, col, 1) < upper_blue(1)
            dst_hsv(row, col, 1) = src_hsv(row, col, 1);
        end
    end
end

% Saturation 
for row = 1:rows
    for col = 1:cols
        if lower_blue(2) < src_hsv(row, col, 2) && src_hsv(row, col, 2) < upper_blue(2)
            dst_hsv(row, col, 2) = src_hsv(row, col, 2);
        end
    end
end

% Value 
for row = 1:rows
    for col = 1:cols
        if lower_blue(3) < src_hsv(row, col, 3) && src_hsv(row, col, 3) < upper_blue(3)
            dst_hsv(row, col, 3) = src_hsv(row, col, 3);
        end
    end
end        
dst_rgb = hsv2rgb(dst_hsv);

figure(1);
subplot(2, 5, 1), imshow(src_rgb), title('src\_rgb');
subplot(2, 5, 2), imshow(src_hsv), title('src\_hsv');
subplot(2, 5, 3), imshow(src_hsv(:, :, 1)), title('src\_h');
subplot(2, 5, 4), imshow(src_hsv(:, :, 2)), title('src\_s');
subplot(2, 5, 5), imshow(src_hsv(:, :, 3)), title('src\_v');

subplot(2, 5, 6), imshow(dst_rgb), title('dst\_rgb');
subplot(2, 5, 7), imshow(dst_hsv), title('dst\_hsv');
subplot(2, 5, 8), imshow(dst_hsv(:, :, 1)), title('dst\_h');
subplot(2, 5, 9), imshow(dst_hsv(:, :, 2)), title('dst\_s');
subplot(2, 5, 10), imshow(dst_hsv(:, :, 3)), title('dst\_v');
