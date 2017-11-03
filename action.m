function [hdr] = action(filelist,ldrpath, hdrpath,stack_exposure, i, nExposures, write_counter ,outputformat)

var ldr_stack;
        stacklist = filelist(i:(i+(nExposures-1)), :);
        [ldr_stack, ~] = readLDRStack(ldrpath, stacklist, 1);
%disp(stacklist);
        [lin_fun, ~] = DebevecCRF(ldr_stack, stack_exposure);       
        hdr = BuildHDR(ldr_stack, stack_exposure, 'LUT', lin_fun, 'Deb97', 'log');

        %write_counter = j + 1;               
        tmo = ReinhardTMO(hdr);
        tmo_g = tmo.^(1/2.2);
        imwrite (tmo_g, fullfile(hdrpath, sprintf('%d.JPG', (write_counter))) );

        hdr_small = imresize(hdr, [500 500], 'bilinear'); 
        switch(outputformat)
            case 'hdr'
                hdrwrite(hdr_small, fullfile(hdrpath, sprintf('%05d.hdr', (write_counter))));                
                
            case 'exr'
                exrwrite(hdr_small, fullfile(hdrpath, sprintf('%05d.exr', (write_counter)))); 
    
        end
        
    
    fprintf('\n Merged HDR %05d written to disk.\n', (write_counter));
    clear ldr_stack;

end

