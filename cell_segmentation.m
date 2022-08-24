Ipc = tiffreadnew2('C:\Users\yshukkk\Desktop\YSH SMCB\matlab_code\SJ_imaging_analysis_original\pc.tif');
a = size(Ipc);
CONST = loadConstants ('100XEc',0);
bw = struct;
bw_SS = struct;

for p = 1:a(2)
    
    %I_new = I(1:4096,1:4096);
    
    imaging_pc = Ipc(p).data;
    
    cell_seg(p) = CONST.seg.segFun(imaging_pc, CONST, '', 'test', []);
    a = cell_seg(p).segs.segs_3n + cell_seg(p).segs.segs_bad + cell_seg(p).segs.segs_good;
    a = imcomplement(a);
    a = imbinarize(a);
    a = bwareafilt(a, [100 400]);
    
    bw(p).i = a;
    bw_SS(p).i = imbinarize(cell_seg(p).regs.regs_label);
    
end

save('cell_segmentation','cell_seg');
save('BW_segmentation','bw');
save('BW_segmentation_full_al','bw_SS');