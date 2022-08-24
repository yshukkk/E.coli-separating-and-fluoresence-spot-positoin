data = zeros(1,1);

Ipc = tiffreadnew2('C:\Users\yshukkk\Desktop\YSH SMCB\matlab_code\SJ_imaging_analysis_original\pc.tif');
Ifl = tiffreadnew2('C:\Users\yshukkk\Desktop\YSH SMCB\matlab_code\SJ_imaging_analysis_original\fl.tif');
a = size(Ipc);
CONST = loadConstants ('100XEc',0);

for p = 1:a(2)
    
    %I_new = I(1:4096,1:4096);
    
    imaging_pc = Ipc(p).data;
    imaging_fl = Ifl(p).data;
    
    tt(p) = CONST.seg.segFun(imaging_pc, CONST, '', 'test', []);
    bw = imbinarize(tt(p).regs.regs_label);
    
    subplot(1, 2, 1);
    imshow(imaging_pc, []);
%     title('PC Image', num2str(p),'FontSize', 10, 'Interpreter', 'None');
%     axis('on', 'image');
%     hp = impixelinfo();
%     hold on
    
    x=[];
    y=[];
    n=0;
    button = 1;
    
    se90 = strel('line',4,90);
    se0 = strel('line',4,0);
    seD = strel('disk',2);
    sedisk = strel('disk',5);
    
    q = 1;
    
    while button == 0
        
        
        
%         [xd,yd]=ginput(2);
%         
%         x1 = round(xd(1));
%         x2 = round(xd(2));
%         y1 = round(yd(1));
%         y2 = round(yd(2));
%         
%         if x1>x2
%             break;
%         end
%         
%         Ipc_crop = imaging_pc(y1:y2,x1:x2);
%         Ifl_crop = imaging_fl(y1:y2,x1:x2);
% 
%         bw = imbinarize(Ipc_crop);
%         bw = imcomplement(bw);
%         Ifl_cut = double(Ifl_crop).*double(bw);
%         Ipc_cut = double(Ipc_crop).*double(bw);
        
        subplot(1, 2, 2);
        imshow(bw);
        hold on
        
         s = regionprops(bw, 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Centroid','Perimeter', 'Area');
%         bw_rot = imrotate(bw,-s.Orientation+pi/2);
%         s_rot = regionprops(bw_rot, 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Centroid','Perimeter', 'Area');
%         
%         bw_rot = imtranslate(bw_rot,[-s_rot.Centroid(1)+length(bw)/2, -s_rot.Centroid(2)+length(bw(:,1))/2]);
%         bw_rot = imcrop(bw_rot,[length(bw_rot(1,:))/2-20 length(bw_rot(:,1))/2-20 40 40]);
%         
%         Ifl_rot = imrotate(Ifl_cut,-s.Orientation+pi/2);
%         Ifl_rot = imtranslate(Ifl_rot,[-s_rot.Centroid(1)+length(Ifl_cut)/2, -s_rot.Centroid(2)+length(Ifl_cut(:,1))/2]);
%         Ifl_rot = imcrop(Ifl_rot,[length(Ifl_rot(1,:))/2-20 length(Ifl_rot(:,1))/2-20 40 40]);
%         
%         Ipc_rot = imrotate(Ipc_cut,-s.Orientation+pi/2);
%         Ipc_rot = imtranslate(Ipc_rot,[-s_rot.Centroid(1)+length(Ipc_cut)/2, -s_rot.Centroid(2)+length(Ipc_cut(:,1))/2]);
%         Ipc_rot = imcrop(Ipc_rot,[length(Ipc_rot(1,:))/2-20 length(Ipc_rot(:,1))/2-20 40 40]);
%         
%         frame_bw(:,p) = sum(bw_rot);
%         frame_fl(:,p) = sum(Ifl_rot)./sum(bw_rot);
%         frame_pc(:,p) = sum(Ipc_rot)./sum(bw_rot);
%         
%         phi = linspace(0,2*pi,50);
%         cosphi = cos(phi);
%         sinphi = sin(phi);
        
        for k = 1:length(s)
            xbar = s(k).Centroid(1);
            ybar = s(k).Centroid(2);
            eccen(k) = s(k).MajorAxisLength/s(k).MinorAxisLength;
            a = s(k).MajorAxisLength/2;
            b = s(k).MinorAxisLength/2;
            theta = pi*s(k).Orientation/180;
            R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
            xy = [a*cosphi; b*sinphi];
            xy = R*xy;
            x = xy(1,:) + xbar;
            y = xy(2,:) + ybar;
            
            a_nm = a/540*200;
            b_nm = b/540*200;
            area = s(k).Area*(200/540)^2;
            perimeter = s(k).Perimeter*200/540;
            circularity = 4*s(k).Area*pi()/(s(k).Perimeter)^2;
            
            plot(x,y,'r','LineWidth',2);
        end
        
        hold off
       
%         subplot(1,2,1);
%         plot(x1+x,y1+y,'r','LineWidth',1);
%         
%         prompt = 'Do you want save? type - p: ';
%         str = input(prompt,'s');
%         if str == 'p'
%             for k = 1:7
%                 switch k
%                     case 1
%                         data(q,k) = x1+round(xbar);
%                     case 2
%                         data(q,k) = y1+round(ybar);
%                     case 3
%                         data(q,k) = a_nm;
%                     case 4
%                         data(q,k) = b_nm;
%                     case 5
%                         data(q,k) = theta;
%                     case 6
%                         data(q,k) = area;
%                     case 7
%                         data(q,k) = perimeter;
%                 end
%             end
%             
%             disp(q);
%             q = q+1;
%             
%             subplot(1,2,1);
%             plot(x1+x,y1+y,'r','LineWidth',2);
%             
%         else
%             subplot(1,2,1);
%             plot(x1+x,y1+y,'b','LineWidth',2);
%         end
%         
%         %subplot(2, 2, 3);
%         %imshow(BWs);
%         
%         %subplot(2, 2, 4);
%         %imshow(BWfinal);
    end
    
    hold off

end
