function mergeHDRimages()
%% This function merges the HDR images from stacks of Canon input LDR images

%% Path information gathered from the user
     prompt = {'Enter LDR image folder path: ',... 
               'Enter HDR image folder path: ',...
               'Input Format: ' ...
               'Converitng to: (hdr/exr) ',...
               'Enter the number of exposures (per image stack)'};
    dlg_title = '*****IMAGE INFORMATION DIALOG*****';    
    num_lines = [1 75; 1 75; 1 50; 1 50; 1 50;];
    defaultAns = {'/Users/ecntrk/Documents/onlyslf1/untitled folder/',...
                  '/Users/ecntrk/Desktop/avv/', ...
                  'JPG', 'hdr', '7'};
    inputString = inputdlg(prompt, dlg_title, num_lines, defaultAns); 
    if(isempty(inputString)) %if user presses cancel
       return;
    end
    ldrpath = inputString{1};    
    hdrpath = inputString{2};
    inputformat = inputString{3};
    outputformat = inputString{4};
    nExposures = str2double(inputString{5});
%% Gather the file information from the LDR folder
% we assume they are jpg images (if something else change the extension)
% this portion also gathers the exposure information (one time processing)
% to reduce computation.
    filelist = dir(fullfile(ldrpath, ['*.' inputformat]));
    disp(filelist);
    [stack_exposure] = ldrStackInfo(ldrpath,filelist, nExposures);
    
%% Processing the debayer images in the directory   
    rem_imgs = mod(numel(filelist), (nExposures));
    nFrames = uint16(numel(filelist)/(nExposures));
    if (rem_imgs > 0)
        warning('Number of images in the directory is not an exact multiple of exposure stack.Processing will stop at exact multiple.Remaining images will remain unprocessed');
        fprintf('\nNumber of images to be processed: %d', nFrames);
    end 
    
%% Merge LDR to HDR // might write a more elegant solutions some day    
    i = 1;
    %while(i < numel(filelist))
    %disp(nFrames);
    parfor j = 35:nFrames-1
        i = j*nExposures +1;
        action(filelist,ldrpath, hdrpath,stack_exposure, i, nExposures, j+1, outputformat);
            
    end                        
    fprintf('\n\n HDR MERGE COMPLETE....\n');
end