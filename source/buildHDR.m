function buildHDR()
%% This function merges the HDR images from stacks of Canon input LDR images

%% Path information gathered from the user
     prompt = {'Enter LDR image folder path: ',... 
               'Enter HDR image folder path: ',...
               'Input Format: ' ...
               'Converitng to: (hdr/hdrLatlong/hdrsmall/exr) ',...
               'Tonemap them? (Y/N)',...
               'Enter the number of exposures (per image stack)'};
    dlg_title = '***** build HDR from LDR *****';
    num_lines = [1 75; 1 75; 1 50; 1 50; 1 50; 1 50;];
    defaultAns = {%'~/Documents/lightprobes/',...
                  %'~/Documents/lightprobes/HDR/', ...
                  '/Users/ecntrk/Documents/onlyslf1/untitled folder/',...
                  '/Users/ecntrk/Desktop/', ...
                  'JPG', 'hdrLatlong', 'N', '7'};
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

    if(strcmp(outputformat, 'hdrLatlong')==1)
        %trying to create the big and small directory 
        %if it is not there already.
        [~,~,msgID] = mkdir(hdrpath, 'big');
        if(strcmp(msgID, 'MATLAB:MKDIR:DirectoryExists') == 1)
            disp(strcat(strcat(hdrpath,'big/'), ' already exists'));
        end
        [~,~,msgID] = mkdir(hdrpath, 'small');
        if(strcmp(msgID,'MATLAB:MKDIR:DirectoryExists')==1)
            disp(strcat(strcat(hdrpath,'small/'), ' already exists'));
        end
    end
                
    global filelist;    
    global stack_exposure;
    
    filelist = dir(fullfile(ldrpath, ['*.' inputformat]));
    [stack_exposure] = ldrStackInfo(ldrpath,filelist, nExposures);
       % disp(filelist);

%% Processing the debayer images in the directory   
    rem_imgs = mod(numel(filelist), (nExposures));
    nFrames = uint16(numel(filelist)/(nExposures));
    if (rem_imgs > 0)
        warning('Number of images in the directory is not an exact multiple of exposure stack.Processing will stop at exact multiple.Remaining images will remain unprocessed');
        fprintf('\nNumber of images to be processed: %d', nFrames);
    end 
    
%% Merge LDR to HDR   
   tic;
    for j = 5:7
        i = j*nExposures+1;
        action(i,(i+nExposures-1),j+1);
         
    end                        
    fprintf('\n\n HDR MERGE COMPLETE....\n');
    fprintf('Wrote %d files\n',nFrames);
    fprintf('Took %f Minutes\n',(toc/60));
    
end