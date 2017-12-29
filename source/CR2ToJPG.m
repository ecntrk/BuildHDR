function CR2ToJPG()
% Converts CR2 files to various LDR formats. Optimised for Canon 5Dmk3
% fisheye images. if it is a fisheye, it'll crop the center of the image.
% author: debmalya.01@gmail.com

prompt = {'image folder path: ',... 
               'Converitng to: (jpg, png, tif) ',...
               'Are these fisheye? (Y/N)',...
               'Xmin',...
               'Ymin',...
               'Width',...
               'Height'};
    dlg_title = '***** Crop and Convert from CR2 *****';
    num_lines = [1 75; 1 75; 1 50; 1 50; 1 50; 1 50; 1 50;];
    defaultAns = {'~/Desktop/av',...
                  'jpg', ...
                  'Y',...
                  '955', '1', '3839', '3840'};
    inputString = inputdlg(prompt, dlg_title, num_lines, defaultAns); 
    if(isempty(inputString)) %if user presses cancel
       return;
    end
    folderPath = inputString{1};
    type = inputString{2};
    fisheye = inputString{3};
    Xmin = str2int(inputString{4});
    Ymin = str2int(inputString{5});
    Width = str2int(inputString{6});
    Height = str2int(inputString{7});

if(~exist('fisheye', 'var'))
    fisheye = 1;
end

filelist = dir(fullfile(folderPath, '*.CR2'));
N = numel(filelist);
fprintf('\nConverting %d CR2 files to %s..\n', (N), type);
parfor i = 1: N
im = imread([folderPath,'/', filelist(i).name]);
if(fisheye==1)
    img = imcrop(im,[Xmin Ymin Width Height]);
    filename = sprintf('%05d.%s',i, type);
    imwrite(img, [folderPath,'/',filename]);
else
    filename = sprintf('%05d.%s',i, type);
    imwrite(im, [folderPath,'/',filename]);    
end

end
end