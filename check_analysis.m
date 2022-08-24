
a = size(spot);
i = 1;
button = 1;

while button == 1
    figure(1)
    subplot(1,2,1)
    imshow(double(Ipc(i).data)+double(bw(i).i)*300,[])
    
    subplot(1,2,2)
    imshow(If(i).data,[])
    
    hold on
    for j = 1:spot(i).spot_N-1
        viscircles([spot(i).x(j),spot(i).y(j)],2,'linewidth',0.1);
    end
    hold off
    
    prompt = 'Type frame #: or [E]';
    str = input(prompt);
    if str == 'E'
        button = 0;
    elseif isempty(str)
        i = i+1;
    else
        i = str;
    end
end