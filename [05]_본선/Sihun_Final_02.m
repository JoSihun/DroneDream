clear()
% HSV Threshold Green
thdown_green = [0.25, 40/240, 80/240];
thup_green = [0.40, 240/240, 240/240];
% HSV Threshold Blue
thdown_blue = [0.5, 0.35, 0.25];
thup_blue = [0.75, 1, 1];

droneObj = ryze()
cameraObj = camera(droneObj)
% takeoff(droneObj);
% v = VideoReader('test_video2.mp4');
while 1
    % HSV Convert
    disp('HSV Converting');
%     frame = readFrame(v);
    frame = snapshot(cameraObj);
    src_hsv = rgb2hsv(frame);
    src_h = src_hsv(:,:,1);
    src_s = src_hsv(:,:,2);
    src_v = src_hsv(:,:,3);
    [rows, cols, channels] = size(src_hsv);

    % Image Preprocessing
    bw1 = (0.5 < src_h)&(src_h < 0.75) & (0.15 < src_s)&(src_s < 1) & (0.25 < src_v)&(src_v < 1);   % 파란색 검출
    
    
    
    
    
    bw2 = imfill(bw1,'holes');                                                                      % 구멍을 채움
    %구멍을 채우기 전과 후를 비교하여 값이 일정하면 0, 변했으면 1로 변환
    for row = 1:rows
        for col = 1:cols
            if bw1(row, col) == bw2(row, col)
                bw2(row, col)=0;
            end
        end
    end

    % Detecting Center
    disp('Image Processing 2: Detect Center');
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
    center_row = center_row / count_pixel;
    center_col = center_col / count_pixel;
    camera_mid_row = rows / 2;
    camera_mid_col = cols / 2;
    
    subplot(2, 2, 1), imshow(frame); hold on;
    plot(center_col, center_row, 'r*'); hold off;
    subplot(2, 2, 3), imshow(bw1); hold on;
    plot(center_col, center_row, 'r*'); hold off;
    subplot(2, 2, 4), imshow(bw2); hold on;
    plot(center_col, center_row, 'r*'); hold off;
%     imshow(bw1);
%     imshow(bw2);
    
%     subplot(1, 2, 2), imshow(dst_hsv1)
%     plot(center_col, center_row, 'r*'); hold off;
%     subplot(2, 2, 2), imshow(gray_thres_dst); hold on;
%     plot(center_col, center_row, 'r*'); hold off;
%     subplot(2, 2, 3), imshow(dst_hsv1);
%     subplot(2, 2, 4), imshow(dst_hsv2);
end