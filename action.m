function [hdr] = action(i,  write_counter)

    global ldrpath;
    global hdrpath;
    global outputformat;
    global needTonemap;
    global nExposures;
    global filelist;    
    global stack_exposure;
    
var ldr_stack;
        stacklist = filelist(i:(i+(nExposures-1)), :);
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

