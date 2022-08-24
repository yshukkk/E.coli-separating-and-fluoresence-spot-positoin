t_int = 0.75;
min_I = 200;
max_I = 2000;

image = VideoWriter('cell1_image','Motion JPEG AVI');
image.FrameRate = 1;  %just to be cinematic
image.Quality=100; %no compression
open(image);
figure(1)

for i = 1:97
    subplot(1,2,1)
    I = imread(['rotated_IF' num2str(i) '.tif']);
    imshow(I,[200 max(max(I))]);
    %text(0,0,['frame: ' num2str(i) '/' num2str(time) ' min'],'Color','red','FontSize',10)
    %text(10,10,num2str(i),'Color','red','FontSize',10)
    
    subplot(1,2,2)
    I2 = imread(['rotated_IPC' num2str(i) '.tif']);
    imshow(I2,[]);
    
    hold on
    
    s = regionprops(I2, 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Centroid','Perimeter', 'Area');
    
    t = linspace(0,pi*2);
    xbar = s.Centroid(1);
    ybar = s.Centroid(2);
    a = s.MajorAxisLength/2;
    b = s.MinorAxisLength/2;
    theta = pi*s.Orientation/180;
    R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    xy = [a*cos(t); b*sin(t)];
    xy = R*xy;
    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;
    
    plot(x,y,'r','LineWidth',2);
    
%     if celldata(i,11) > celldata(i,12)
%         rx = celldata(i,11);
%         ry = celldata(i,12);
%     else
%         ry = celldata(i,11);
%         rx = celldata(i,12);
%     end
%     
%     
%     t = linspace(0,pi*2);
%     x = 21 + rx*cos(t);
%     y = 21 + ry*sin(t);
%     plot(x,y,'r');
%     text(pol(1,1),pol(1,2),'X','color','r');
%     text(pol(2,1),pol(2,2),'X','color','r');
%     text(xcenter,ycenter,'X','color','r');
    hold off
    
    frame = getframe(1); %get image of what is displayed in the figure
    writeVideo(image, frame);
    
    tetha_1(i) = theta;
end

close(image);