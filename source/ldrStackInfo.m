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

        digicam = img_info.DigitalCamera;
        exposure_time = digicam.ExposureTime;
        aperture = digicam.FNumber;
        iso = digicam.ISOSpeedRatings;

        [~, value] = EstimateAverageLuminance(exposure_time, aperture, iso);
        stack_exposure(i) = value;
    end
    
end

