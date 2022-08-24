function [out,a,b]=location_2Dheatmap(data,snr1,snr2,x,y,sz1,sz2)

data.

datasize=size(data);
xcenter=data(1:end,1);
ycenter=data(1:end,2);
xfar=data(1:end,3);
yfar=data(1:end,4);
xdot=data(1:end,5)-x;
ydot=data(1:end,6)-y;
rx=data(1:end,10);
ry=data(1:end,11);
snr=data(1:end,13);

xdotnew1=zeros(1,datasize(1));
ydotnew1=zeros(1,datasize(1));
snrnew=zeros(1,datasize(1));
yflist=zeros(1,datasize(1));
xflist=zeros(1,datasize(1));

for i=1:datasize(1)
    if ( snr(i) >= snr1 ) && (snr(i) < snr2)
        if rx(i)>ry(i)
            yf=rx(i);
            xf=ry(i);
        else
            yf=ry(i);
            xf=rx(i);
        end
        if yf >= sz1 && yf < sz2
            yflist(i)=yf;
            xflist(i)=xf;
            cos=(yfar(i)-ycenter(i))/yf;
            sin=(xfar(i)-xcenter(i))/yf;
            xdotnew1(i)=(xdot(i)-xcenter(i))*cos-(ydot(i)-ycenter(i))*sin;
            xdotnew1(i)=xdotnew1(i)/xf;
            ydotnew1(i)=(xdot(i)-xcenter(i))*sin+(ydot(i)-ycenter(i))*cos;
            ydotnew1(i)=ydotnew1(i)/yf;
            snrnew(i)=snr(i);
        end
    end
end

yf1=[];
xf1=[];
snr11=[];

for i=1:datasize(1)
    if ( snr(i) >= snr1 ) && (snr(i) < snr2)
        if yflist(i) >= sz1 && yflist(i) < sz2
            yf1=[yf1 yflist(i)];
            xf1=[xf1 xflist(i)];
            snr11=[snr11 snrnew(i)];
        end
    end
end

xdotnew=[];
ydotnew=[];

yf1avr=mean(yf1);
yf1std=std(yf1);
xf1avr=mean(xf1);
xf1std=std(xf1);

yfavr=yf1avr/xf1avr;

for i=1:datasize(1)
    if ( snr(i) >= snr1 ) && (snr(i) < snr2)
        if yflist(i) >= sz1 && yflist(i) < sz2
            xdotnew=[xdotnew; xdotnew1(i)];
            ydotnew=[ydotnew; ydotnew1(i)*yfavr];
        end
    end
end

xavr=mean(abs(xdotnew));
xstd=std(abs(xdotnew));

yavr=mean(abs(ydotnew));
ystd=std(abs(ydotnew));

davr=mean(sqrt(xdotnew.^2+ydotnew.^2));
dstd=std(sqrt(xdotnew.^2+ydotnew.^2));

tavr=mean(snr11);
tstd=std(snr11);

for i=1:100
    picx(i)=-1+(i-1)/50;
    picy(i)=sqrt((1^2-picx(i)^2)/5)+0.5;
end
for i=101:200
    picx(i)=1-(i-100)/50;
    picy(i)=-sqrt((1^2-picx(i)^2)/5)-0.5;    
end

picx(201)=-1;
picy(201)=0.5;


A=abs(xdotnew);
B=-A;
C=[A;B];
hx1= hist(C, -2:0.2:2);
hx1= hx1/sum(hx1);
bar(-2:0.2:2,hx1);
a=[-2:0.2:2;hx1]';

clear A B C

A=abs(ydotnew);
B=-A;
C=[A;B];
hx2=hist(C,-4:0.4:4);
hx2=hx2/sum(hx2);
bar(-4:0.4:4,hx2);
b=[-4:0.4:4;hx2]';

% 2D heat map

count=hist2d([abs(xdotnew),abs(ydotnew)],0:0.2:1.5,0:0.2:4);
count=count/size(xdotnew,1);
aa=fliplr(count);
bb=flipud(count);
cc=fliplr(bb);
map=[cc, bb;aa,count];

% Create Gaussian filter matrix:
[xG, yG] = meshgrid(-5:5);
sigma = 1.5;
g = exp(-xG.^2./(2.*sigma.^2)-yG.^2./(2.*sigma.^2));
g = g./sum(g(:));

figure

hold
imagesc(-3:0.2:3,-1:0.2:1,conv2(map,g,'same'));
plot(picy*yfavr,picx,'w')

%a(:,1)=hx1(:);
%b(:,1)=hy1(:);

% % 2D heat map (symmmetry X)
% 
% acount=hist2d([xdotnew,ydotnew],-1.5:0.2:1.5,-4:0.2:4);
% acount=acount/size(xdotnew,1);
% 
% figure
% hold
% imagesc(-3:0.2:3,-1:0.2:1,conv2(acount,g,'same'));
% plot(picy*yfavr,picx,'w')

out={[xdotnew,ydotnew],[tavr; tstd; xavr; xstd; yavr; ystd; davr; dstd; size(xdotnew,1); xf1avr; xf1std;yf1avr;yf1std]};

xstd
ystd

% bx=abs(xdotnew);
% by=abs(ydotnew);
% b_d=sqrt(xdotnew.^2+ydotnew.^2);

% [xstats]=bootstrp(1000,@mean,bx);
% [ystats]=bootstrp(1000,@mean,by);
% [dstats]=bootstrp(1000,@mean,b_d);
% xbavr=mean(xstats);
% xbse=std(xstats);
% ybavr=mean(ystats);
% ybse=std(ystats);
% dbavr=mean(dstats);
% dbse=std(dstats);
% 
% 
% out_b=[xbavr,ybavr,xbse,ybse,dbavr,dbse];



end

%A Simple function that makes a 2D histgram developed by Sisi Ma (sisima[at]rci.rutgers.edu )

% Input:    data: two cols, x value; y value
%             xrange: range and bins for x value (edges)
%             yrange: range and bins for y value (edges)
%Output: Count of a specifice (x,y) bin combination; 
%       Suggested visualizing tool: I like to use imagesc; bar3 will work fine
%       too; have to change axis label though


function count=hist2d(data, xrange, yrange)

    for i=1:length(xrange)-1
        data((data(:,1)>xrange(i))&(data(:,1)<=xrange(i+1)),3)=i;
    end

    for i=1:length(yrange)-1
        data((data(:,2)>yrange(i))&(data(:,2)<=yrange(i+1)),4)=i;  
    end

    count=zeros(length(xrange)-1,length(yrange)-1);

    data=data(data(:,3)>0,:); % if a data point is out of the x range, throw it away
    data=data(data(:,4)>0,:);% if a data point is out of the y range, throw it away
    
    for i=1:size(data,1)
        count(data(i,3),data(i,4))=count(data(i,3),data(i,4))+1; 
    end

end



