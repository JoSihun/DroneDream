% HSV Threshold Green
thdown_green = [0.25, 40/240, 80/240];
thup_green = [0.40, 240/240, 240/240];
% HSV Threshold Blue
thdown_blue = [0.5, 0.35, 0.25];
thup_blue = [0.75, 1, 1];

clear()
droneObj = ryze()
cameraObj = camera(droneObj)
takeoff(droneObj);
while 1
    % HSV Convert
    disp('HSV Converting');
    frame = snapshot(cameraObj);
    src_hsv = rgb2hsv(frame);
    src_h = src_hsv(:,:,1);

    detect_blue = (0.5 < src_h) & (src_h < 0.75);
    [row, col] = find(detect_blue);
    if ~isempty(row) && ~isempty(col)
        XblueCenter = round(mean(col));
        YblueCenter = round(mean(row));
    end
    imshow(frame); hold on;
    plot(XblueCenter, YblueCenter, 'r*'); hold off;

    % 중앙 점을 따라가는 함수
    if YblueCenter < 330
        moveup(drone, 0.6);
        pause(1);
    elseif YblueCenter > 390
        movedown(drone, 0.5);
        pause(1);
    else
        if XblueCenter < 440
            moveleft(drone, 0.6);
            pause(1);
        elseif XblueCenter > 520
            moveright(drone, 0.5);
            pause(1);
        else
            break;
        end
    end

    clear XgreenCenter;
    clear YgreenCenter;
end