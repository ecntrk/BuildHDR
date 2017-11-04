function [stack_exposure] = ldrStackInfo(folder, filelist, nExposures )
%% This function calculates the modified exposure stack
% The stack exposure is calculated by an estimated luminance gathered from
% the exif information of the images.

stack_exposure = zeros(nExposures, 1);

    for i=1:nExposures
        %Read exif information   
        imgname = fullfile(folder, filelist(i).name);
        img_info = imfinfo(imgname);        
        if(isempty(img_info))
            error('\n Exif Information is empty \n');            
        end 

        exposure_time = img_info.DigitalCamera.ExposureTime;
        aperture = img_info.DigitalCamera.FNumber;
        iso = img_info.DigitalCamera.ISOSpeedRatings;

        [~, value] = EstimateAverageLuminance(exposure_time, aperture, iso);
        stack_exposure(i) = value;
    end
    
end

