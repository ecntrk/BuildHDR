function buildHDR()
%% This function merges the HDR images from stacks of Canon input LDR images

%% Path information gathered from the user
     prompt = {'Enter LDR image folder path: ',... 
               'Enter HDR image folder path: ',...
               'Input Format: ' ...
               'Converitng to: (hdr/exr) ',...
               'Tonemap them? (Y/N)',...
               'Enter the number of exposures (per image stack)'};
    dlg_title = '***** build HDR from LDR *****';
    num_lines = [1 75; 1 75; 1 50; 1 50; 1 50; 1 50;];
    defaultAns = {'~/Documents/lightprobes/',...
                  '~/Documents/lightprobes/HDR/', ...
                  'JPG', 'hdr', 'N', '7'};
    inputString = inputdlg(prompt, dlg_title, num_lines, defaultAns); 
    if(isempty(inputString)) %if user presses cancel
       return;
    end
    global ldrpath;
    global hdrpath;
    global outputformat;
    global needTonemap;
    global nExposures;
    ldrpath = inputString{1};
    hdrpath = inputString{2};
    inputformat = inputString{3};
    outputformat = inputString{4};
    needTonemap = inputString{5};
    nExposures = str2double(inputString{6});
%% Gather the file information from the LDR folder
% we assume they are jpg images (if something else change the extension)
% this portion also gathers the exposure information (one time processing)
% to reduce computation.
    global filelist;    
    global stack_exposure;
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
        action(i, j+1);
            
    end                        
    fprintf('\n\n HDR MERGE COMPLETE....\n');
end