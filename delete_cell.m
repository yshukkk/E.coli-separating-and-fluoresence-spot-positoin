a = size(bw);
bw_d = struct;

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

for p = 1:a(2)
    
    bw_get = bw(p).i;

    imshow(Ipc(p).data,[]);
    hold on
    button = 1;
    
    s = regionprops(bw_get, 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Centroid','Perimeter', 'Area');
    
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
        
        plot(x,y,'r','LineWidth',1);
    end
    
    while button == 1
        
        [xd,yd]=ginput(1);

        bw_sel=bwselect(bw_get,xd,yd,4);
        d = regionprops(bw_sel, 'Orientation', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Centroid','Perimeter', 'Area');
        if ~isempty(d)
            xbar = d.Centroid(1);
            ybar = d.Centroid(2);
            eccen = d.MajorAxisLength/s(k).MinorAxisLength;
            a = d.MajorAxisLength/2;
            b = d.MinorAxisLength/2;
            theta = pi*d.Orientation/180;
            R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
            xy = [a*cosphi; b*sinphi];
            xy = R*xy;
            x = xy(1,:) + xbar;
            y = xy(2,:) + ybar;
            
            plot(x,y,'g','LineWidth',1);
            
            bw_get = logical(bw_get-bw_sel);
        else
            disp('click a cell!!')
        end
        
        prompt = 'Do you want more? [y]: ';
        str = input(prompt,'s');
        if isempty(str)
            str = 'y';
        end
        
        if str ~= 'y'
            button = 0;
        end

    end
    
    hold off
    
    bw_d(p).i = bw_get;

end