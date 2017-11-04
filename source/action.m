function action(i, i_end, write_counter)

    global ldrpath;
    global hdrpath;
    global outputformat;
    global needTonemap;
    global nExposures;
    global filelist;
    global stack_exposure;

    
var ldr_stack;
    %fprintf('\ni: %d, %d,\n',i,i_end );
        stacklist = filelist(i:i_end);
%disp(stacklist);
[ldr_stack, ~] = readLDRStack(ldrpath, stacklist, 1);
        [lin_fun, ~] = DebevecCRF(ldr_stack, stack_exposure);       
        hdr = BuildHDR(ldr_stack, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log');
        
        %%tonemapping
        if(needTonemap == 'Y')
            tmo = ReinhardTMO(hdr);
            tmo_g = tmo.^(1/2.2);
            imwrite (tmo_g, fullfile(hdrpath, sprintf('%d.JPG', (write_counter))) );
        end
        
        switch(outputformat)
            case 'hdrLatlong'
                
                %because we dont want huge lightprobes in any case.
                hdr_small = imresize(hdr, [500 500], 'bilinear');
                
                %actual conversion to fisheye
                op1 = fish2Cube(hdr_small);
                %including  the 40% size 'small' image too
                op2 = imresize(op1, 0.4, 'bilinear');
                RemoveSpecials(ClampImg(op2, 1e-4, max(op2(:)) ));

                hdrwrite(op1, fullfile(hdrpath, sprintf('/big/%05d.hdr', (write_counter))));                
                hdrwrite(op2, fullfile(hdrpath, sprintf('/small/%05d.hdr', (write_counter))));                
               
            case 'hdrsmall'
                hdr_small = imresize(hdr, [500 500], 'bilinear');
                hdrwrite(hdr_small, fullfile(hdrpath, sprintf('%05d.hdr', (write_counter))));                
            case 'hdr'
                hdrwrite(hdr, fullfile(hdrpath, sprintf('%05d.hdr', (write_counter))));                
                
            case 'exr'
                exrwrite(hdr, fullfile(hdrpath, sprintf('%05d.exr', (write_counter)))); 
    
        end
        
    
    fprintf('\n Merged HDR %05d written to disk.\n', (write_counter));
    clear ldr_stack;

end

