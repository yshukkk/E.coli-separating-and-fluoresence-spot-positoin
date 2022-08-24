t_int = 0.75;
min_I = 200;
max_I = 2000;
BF = tiffreadnew2('BF.tif');
FL = tiffreadnew2('488nm.tif');

image = VideoWriter('cell_image','Motion JPEG AVI');
image.FrameRate = 24;  %just to be cinematic
image.Quality=100; %no compression
open(image);
figure(1)

for i = 1:length(BF)
    time = t_int*i;
    
    subplot(1,2,1)
    title('Phase contrast')
    imshow(BF(i).data,[min_I max_I]);
    %text(0,0,['frame: ' num2str(i) '/' num2str(time) ' min'],'Color','red','FontSize',10)
    text(10,10,num2str(i),'Color','red','FontSize',10)
    
    subplot(1,2,2)
    title('Fluorescence')
    imshow(FL(i).data,[]);
    
    frame = getframe(1); %get image of what is displayed in the figure
    writeVideo(image, frame);
end

close(image);