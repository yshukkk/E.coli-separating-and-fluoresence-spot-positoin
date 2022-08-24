% If = tiffreadnew2('C:\Users\yshukkk\Desktop\YSH SMCB\UnaG\12-31-2020 BR time test-20210104T033429Z-001\12-31-2020 BR time test\flow, temp (1)\45s interval (gel ¹Ù±ù)\488nm.tif');
% Ipc = tiffreadnew2('C:\Users\yshukkk\Desktop\YSH SMCB\UnaG\12-31-2020 BR time test-20210104T033429Z-001\12-31-2020 BR time test\flow, temp (1)\45s interval (gel ¹Ù±ù)\BF.tif');
% 
% bw = cell_segmentation_function(Ipc);
% save('BW_segmentation','bw');

a = size(If);
spot = struct;
N_spot = 2;


for p = 1:a(2)
%% fluorescence image modification
  %2021-1-4 YSH
    disp(['frame #: ', num2str(p)]);
    
    Image_f = If(p).data;
    Image_mask = bw(p).i;
    
    %delete image edge
    Image_mask(1,:) = 0;
    Image_mask(2,:) = 0;
    Image_mask(3,:) = 0;
    Image_mask(510,:) = 0;
    Image_mask(511,:) = 0;
    Image_mask(512,:) = 0;
    
    Image_mask(:,1) = 0;
    Image_mask(:,2) = 0;
    Image_mask(:,3) = 0;
    Image_mask(:,510) = 0;
    Image_mask(:,511) = 0;
    Image_mask(:,512) = 0;
    
    edge_mask = bw(p).i - Image_mask;
    
    %     % Subtract gaussian blurred image to get rid of big structure
    %     hg = fspecial('gaussian' , 210, 30 );
    %     Image_f = Image_f - imfilter(Image_f, hg, 'replicate' );
    %
    %Image_f = Image_f - imgaussfilt(Image_f,30);
    %[~,~,Image_f] = curveFilter(Image_f,1.5);
    cc = bwconncomp(bw(p).i);
    
    x = [];
    y = [];
    sx = [];
    sy = [];
    peak_I = [];
    spot_SNR = [];
    cell_Area = [];
    cell_xCenter = [];
    cell_yCenter = [];
    cell_Orientation = [];
    cell_Majorlength = [];
    cell_Minorlength = [];
    cell_intensity = [];
    spot_xDistance = [];
    spot_yDistance = [];
    spot_xRelative = [];
    spot_yRelative = [];
    spot_N = 1;
    cell_N = 1;
 
    for q=1:cc.NumObjects
    %% 2D gaussian fitting
     % Base on SR's code 2015-02-17, 2D gaussian fitting to determine spot position
     % 2021-01-04, YSH upgrade   
        
        cell_mask = ismember(labelmatrix(cc),q);
        Image_f_bg = [];
        
        if sum(sum(cell_mask.*edge_mask)) == 0
            
            area = sum(sum(cell_mask));
            mean_I = mean(double(Image_f(cell_mask)));
            std_I = std(double(Image_f(cell_mask)));
            
            Image_f_bg = Image_f-mean_I-std_I;
            Image_f_bg = imbinarize(Image_f_bg);
            Image_f_bg = Image_f_bg.*cell_mask;
            
            [labeled,numSignals] = bwlabel(Image_f_bg,8);
            
            spot_area = zeros(1,numSignals);
            signal = zeros(1,numSignals);
            signalsqureSum = zeros(1,numSignals);
            SIGNAL = zeros(1,numSignals);
            
            for j = 1:numSignals
                spot_mask = ismember(labeled,j);
                
                signal(j) = sum(sum(double(Image_f(spot_mask))));
                signalsqureSum(j) = sum(sum(double(Image_f(spot_mask)).*double(Image_f(spot_mask))));
                spot_area(j) = sum(sum(spot_mask));
                SIGNAL(j) = signal(j)/spot_area(j);
            end
            
            % noise calculation
            squresum = sum(double(Image_f(cell_mask)).^2);
            totalSum = sum(double(Image_f(cell_mask)));
            
            bg_squresum = squresum - sum(signalsqureSum);
            bg_squresum = bg_squresum/(area - sum(spot_area));
            bgSum = totalSum - sum(signal);
            bgSum = bgSum/(area - sum(spot_area));
            
            noise = sqrt(bg_squresum - bgSum^2);
            
            % threshold signal condition SNR > 1
            SNR = zeros(1,numSignals);

            for j=1:numSignals
                SNR(j) = (SIGNAL(j)-bgSum)/noise;
                if SNR(j) < 1 %% deletion
                    notspotindex = ismember(labeled,j);
                    Image_f_bg(notspotindex) = 0;
                end
            end
        end
        
        % NumSpot check spot # =< N_spot
        [labeled_all,numSpots] = bwlabel(Image_f_bg,8);

        while numSpots > N_spot
            
            signal = [];
            for j = 1:numSpots
                spot_mask = ismember(labeled_all,j);
                signal(j) = sum(sum(double(Image_f(spot_mask))));
            end
            
            [A,I] = min(signal);
            notspotindex = ismember(labeled_all,I);
            Image_f_bg(notspotindex) = 0;
            [labeled_all,numSpots] = bwlabel(Image_f_bg,8);
        end

        
        % get spots
        [labeled,numSpots] = bwlabel(Image_f_bg,8);

        spot_area2 = zeros(1,numSignals);
        signal2 = zeros(1,numSignals);
        signalsqureSum2 = zeros(1,numSignals);
        SIGNAL2 = zeros(1,numSignals);
        
        if numSpots ~= 0
            for j = 1:numSpots
                spot_mask = ismember(labeled,j);
                
                signal2(j) = sum(sum(double(Image_f(spot_mask))));
                signalsqureSum2(j) = sum(sum(double(Image_f(spot_mask)).*double(Image_f(spot_mask))));
                spot_area2(j) = sum(sum(spot_mask));
                SIGNAL2(j) = signal2(j)/spot_area2(j);
                MaxInt(j) = max(double(Image_f(spot_mask)));
                
                spot_image = double(Image_f).*double(spot_mask);
                [~,index] = max(spot_image);
                [maxrow(j), maxcol(j)] = max(index);
            end
            
            bg_squresum = squresum - sum(signalsqureSum2);
            bg_squresum = bg_squresum/(area - sum(spot_area2));
            bgSum = totalSum - sum(signal2);
            bgSum = bgSum/(area - sum(spot_area2));
            
            noise = sqrt(bg_squresum - bgSum^2);
            
            SNR2 = zeros(1,numSpots);
            for k=1:numSpots
                SNR2(k) = (SIGNAL2(k) - bgSum)/noise;
            end
            
            gaucentx=[];
            gaucenty=[];
            gsx=[];
            gsy=[];
            peakOD=[];
            maxptgau=[];
            
            % 2D Gaussian fitting
            for i=1:numSpots
                %text(maxcol(i),maxrow(i),['    ' num2str(MaxInt(i))],'color','g');
                %text(maxcol(i),maxrow(i),'x','color','g');
                
                maxcent_r=maxrow(i);
                maxcent_c=maxcol(i);
                image25 = double(Image_f(maxcent_r-3:maxcent_r+3,maxcent_c-3:maxcent_c+3));
                %image25=image25-bgSum;
                [gaucentx(i),gaucenty(i),gsx(i),gsy(i),peakOD(i)] = Gaussian2D(image25, 10^-6, 0, bgSum);
                gaucentx(i)=maxcent_c-(4-gaucentx(i));
                gaucenty(i)=maxcent_r-(4-gaucenty(i));
                
                if peakOD(i) > 0
                    %calculate spot position of each cell
                    c = regionprops(bwselect(bw(p).i,gaucentx(i),gaucenty(i)),'Area','Centroid','Orientation','MajorAxisLength','MinorAxisLength');
                    
                    if ~isempty(c) && c.MajorAxisLength <= 40 % At 160X image
                        x(spot_N) = gaucentx(i);
                        y(spot_N) = gaucenty(i);
                        sx(spot_N) = gsx(i);
                        sy(spot_N) = gsy(i);
                        peak_I(spot_N) = peakOD(i);
                        spot_SNR(spot_N) = SNR2(i);

                        phi = pi/180 * c.Orientation;
                        point = [cos(phi), -sin(phi); sin(phi), cos(phi)]*[x(spot_N)-c.Centroid(1); y(spot_N)-c.Centroid(2)];
                        
                        cell_Area(spot_N) = c.Area;
                        cell_xCenter(spot_N) = c.Centroid(1);
                        cell_yCenter(spot_N) = c.Centroid(2);
                        cell_Orientation(spot_N) = phi;
                        cell_Majorlength(spot_N) = c.MajorAxisLength;
                        cell_Minorlength(spot_N) = c.MinorAxisLength;
                        spot_xDistance(spot_N) = point(1);
                        spot_yDistance(spot_N) = point(2);
                        spot_xRelative(spot_N) = point(1)/(c.MajorAxisLength/2);
                        spot_yRelative(spot_N) = point(2)/(c.MinorAxisLength/2);
                        
                        
                        if spot_N > 1 && c.MajorAxisLength ~= cell_Majorlength(spot_N-1)
                            cell_N = cell_N+1;
                        end
                        
                        cell_intensity(cell_N) = sum(double(If(p).data(bwselect(bw(p).i,gaucentx(i),gaucenty(i)))))/c.Area;
                        
                        spot_N = spot_N+1;
                    end
                end
                
                % 5by5 region around gaussian center
%                 gx=round(gaucentx(i));
%                 gy=round(gaucenty(i));
%                 
%                 ptgau=sum(sum(double(Image_f(gy-2:gy+2,gx-2:gx+2))));
%                 ptmaxgau(i)=ptgau/25;
%                 maxptgau(i) = ptmaxgau(i)-bgSum;
                
%                 viscircles([gaucentx(i),gaucenty(i)],1,'linewidth',0.1);
            end        
            
            
        end
    end
    
    spot(p).x = x';
    spot(p).y = y';
    spot(p).sx = sx';
    spot(p).sy = sy';
    spot(p).spot_I = peak_I';
    spot(p).SNR = spot_SNR';
    spot(p).Area = cell_Area';
    spot(p).xcell = cell_xCenter';
    spot(p).ycell = cell_yCenter';
    spot(p).Orientation = cell_Orientation';
    spot(p).Major = cell_Majorlength';
    spot(p).Minor = cell_Minorlength';
    spot(p).cell_intensity = cell_intensity';
    spot(p).xDistance = spot_xDistance';
    spot(p).yDistance = spot_yDistance';
    spot(p).xRelative = spot_xRelative';
    spot(p).yRelative = spot_yRelative';
    spot(p).spot_N = spot_N-1;
    spot(p).cell_N = cell_N;
    
end

his = make_histogram(spot);

save('spot_data','spot');
save('histogram_data','his');