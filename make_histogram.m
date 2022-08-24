function his = make_histogram(spot)
a = size(spot);
his = struct;
h = [];


binx = 10;
h_edgesX = -1:1/binx:1;

biny = 10;
h_edgesY = -1:1/biny:1;

for i = 1:a(2)
    x = abs(spot(i).xRelative);
    y = abs(spot(i).yRelative);
    
    h = histogram(x,h_edgesX);
    his(i).xbin = h.Values';
    
    if length(x) > 1
        h = fitdist(x,'Normal');
        his(i).x_mean = h.mu;
        his(i).x_std = h.sigma;
    elseif length(x) == 1
        his(i).x_mean = x;
        his(i).x_std = 0;
    end
        
        %his(i).x_mean = mean(x);
        %his(i).x_stdError = std(x)/sqrt(spot(i).spot_N);
    
    h = histogram(spot(i).yRelative,h_edgesY);
    his(i).ybin = h.Values';
    
    if length(y) > 1
        h = fitdist(spot(i).yRelative,'Normal');
        his(i).y_mean = h.mu;
        his(i).y_std = h.sigma;
    elseif length(y) == 1
        his(i).y_mean = y;
        his(i).x_std = 0;
    end

    h = histogram2(spot(i).xRelative, spot(i).yRelative, h_edgesX, h_edgesY);
    his(i).TwoDhis = h.Values;
    
    his(i).mean_cell_I = mean(spot(i).cell_intensity);
    his(i).spot_I = mean(spot(i).spot_I);
    
    %     count=hist2d([spot(i).yRelative,spot(i).xRelative],h_edgesY,h_edgesX);
    %     count=count/size(spot(i).xRelative,1);
    %     aa=fliplr(count);
    %     bb=flipud(count);
    %     cc=fliplr(bb);
    %     map=[cc, bb;aa,count];
    %
    %     his(i).TwoDhis = count;
    % Create Gaussian filter matrix:
    %     [xG, yG] = meshgrid(-5:5);
    %     sigma = 1.5;
    %     g = exp(-xG.^2./(2.*sigma.^2)-yG.^2./(2.*sigma.^2));
    %     g = g./sum(g(:));
    %
    %     imagesc(-3:0.2:3,-1:0.2:1,conv2(map,g,'same'));
end
end