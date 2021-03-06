clear()
% HSV Threshold Green
thdown_green = [0.25, 40/240, 80/240];
thup_green = [0.40, 240/240, 240/240];
% HSV Threshold Blue
thdown_blue = [0.5, 0.35, 0.25];        % 파란색의 임계값 범위
thup_blue = [0.75, 1, 1];               
thdown_red = [0.0, 40/240, 65/240];     % 빨간색 점의 임계값 범위
thup_red = [0.0, 240/240, 240/240];
thdown_purple = [0.25, 35/240, 45/240]; % 보라색 점의 임계값 범위
thup_purple = [0.3, 240/240, 240/240];

droneObj = ryze();
cameraObj = camera(droneObj);
takeoff(droneObj);
% v = VideoReader('test_video2.mp4');
while 1
    % HSV Convert
    %frame = readFrame(v);
    frame = snapshot(cameraObj);
    src_hsv = rgb2hsv(frame);
    src_h = src_hsv(:,:,1);
    src_s = src_hsv(:,:,2);
    src_v = src_hsv(:,:,3);
    [rows, cols, channels] = size(src_hsv);

    % Image Preprocessing
    bw1 = (0.5 < src_h)&(src_h < 0.75) & (0.15 < src_s)&(src_s < 1) & (0.25 < src_v)&(src_v < 1);   % 파란색 검출
    
    %사분면 처리 (가운데로 대충 이동)
    left = bw1(:,1:cols/2); right = bw1(:,cols/2:end); up = bw1(1:rows/2,:); down = bw1(rows/2:end,:);
    sum_up = sum(sum(up)); sum_down = sum(sum(down)); sum_left = sum(sum(left)); sum_right = sum(sum(right));
    find_cir = 0;
    
    if(sum_up == 0)
        disp('sum_up = 0');
        movedown(droneObj, 'distance', 0.5);
    elseif(sum_down == 0)
        disp('sum_down = 0');
        moveup(droneObj, 'distance', 0.5);
    elseif(sum_left == 0)
        disp('sum_left = 0');
        moveright(droneObj, 'distance', 0.5);
    elseif(sum_right == 0)
        disp('sum_right = 0');
        moveleft(droneObj, 'distance', 0.5);
    else
        find_cir = 1;
    end
    
    if(find_cir == 1)
        disp('find_cir = 1');
        try
            bw2 = imfill(bw1,'holes');    % 구멍을 채움
            %구멍을 채우기 전과 후를 비교하여 값이 일정하면 0, 변했으면 1로 변환 (0->검은색 1->하얀색)
            for row = 1:rows
                for col = 1:cols
                    if bw1(row, col) == bw2(row, col)
                        bw2(row, col)=0;
                    end
                end
            end
            
            if(sum(sum(bw2)) < 50)
                disp('Cannot find the circle');
                moveback(droneObj, 'distance', 0.2);
                if(sum_up > sum_down)
                   moveup(droneObj, 'distance', 0.3);
                else
                    movedown(droneObj, 'distance', 0.3);
                end
                if(sum_left > sum_right)
                   moveleft(droneObj, 'distance', 0.3);
                else
                    moveright(droneObj, 'distance', 0.3);
                end
            else
            
                % Detecting Center (중점 찾기)
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

                dif_x = camera_mid_col - center_col
                dif_y = camera_mid_row - center_row
%                 go = 0;

                if((dif_x <= -50 || dif_x >= 50) || (dif_y <= -50 || dif_y >= 50))
                    disp('중심 맞추기');
                    if dif_x <= -300
                        moveright(droneObj, 'distance', 0.3)
                    elseif dif_x <= -150
                        moveright(droneObj, 'distance', 0.25)
                    elseif dif_x <= 0
                        moveright(droneObj, 'distance', 0.2)
                    elseif dif_x <= 150
                        moveleft(droneObj, 'distance', 0.2)
                    elseif dif_x <= 300
                        moveleft(droneObj, 'distance', 0.25)
                    else
                        moveleft(droneObj, 'distance', 0.3)
                    end

                    if dif_y <= -300
                        movedown(droneObj, 'distance', 0.3)
                    elseif dif_y <= -150
                        movedown(droneObj, 'distance', 0.25)
                    elseif dif_y <= 0
                        movedown(droneObj, 'distance', 0.2)
                    elseif dif_y <= 150
                        moveup(droneObj, 'distance', 0.2)
                    elseif dif_y <= 300
                        moveup(droneObj, 'distance', 0.2)
                    else
                        moveup(droneObj, 'distance', 0.25)
                    end
                else
                    go = 1;
                end

                if go == 1
                    movedown(droneObj, 'distance', 0.4)
                    moveforward(droneObj, 'distance', 3)
                    land(droneObj)
                    break
                end

                disp('앞으로 전진');
                movedown(droneObj, 'distance', 0.4)
                moveforward(droneObj, 'distance', 0.8)
                if(cnt_red <= 20 || cnt_purple <= 20)       % 해당 픽셀 수가 특정 값일 때 앞으로 이동 (값 정확 X)
                    moveforward(droneObj, 'distance', 1)
                elseif(cnt_red <= 40 || cnt_purple <= 40)
                    moveforward(droneObj, 'distance', 0.5)
                end

                if isequal(isRed, 1)    % 표식이 빨간색이라면 90도 좌회전
                    turn(droneObj, deg2rad(-90))
                elseif isequal(isPurple, 1)     % 표식이 보라색이라면 착륙
                    break;
                end
                
    while 1
        img = snapshot(cam);
        img_hsv = rgb2hsv(img);
        dst_h = img_hsv(:,:,1);
        detected_red = (dst_h>1)+(dst_h<0.05);
    
        if sum(detected_red, 'all') >= 150000
            turn(droneObj, deg2rad(-90));
            break;
        else
            disp('빨간표식 향해 전진');
            moveforward(droneObj, 'Distance', 1.0);
        end
    end


    %%% 이미지 출력
                subplot(2, 2, 1), imshow(frame); hold on;
                plot(center_col, center_row, 'r*'); hold off;
                subplot(2, 2, 3), imshow(bw1); hold on;
                plot(center_col, center_row, 'r*'); hold off;
                subplot(2, 2, 4), imshow(bw2); hold on;
                plot(center_col, center_row, 'r*'); hold off;
    %             imshow(bw1);
    %             imshow(bw2);
            end

        catch exception
            disp('error');
        end
    end
    
end