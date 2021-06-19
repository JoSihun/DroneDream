droneObj = ryze()                                   % 드론객체 선언

distanceX = 2;                                      % 세로길이
distanceY = 2;                                      % 가로길이
distanceD = sqrt(distanceX^2 + distanceY^2);        % 대각선 길이

takeoff(droneObj);                                  % 이륙
moveforward(droneObj, 'Distance', distanceX);       % 전진
moveright(droneObj, 'Distance', distanceY);         % 오른쪽 이동
turn(droneObj, deg2rad(225));                       % 225도 회전
moveforward(droneObj, 'Distance', distanceD);       % 전진
land(droneObj);                                     % 착륙
