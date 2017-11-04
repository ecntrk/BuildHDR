function [op] = fish2Cube(img)
% takes a fisheye HDR image and coverts it into latitude longitude format

[h w z] = size(img);
op = zeros(h, 2*h, 3);
r = floor(h/2);
for j = 1:h
 
for i = 1:2*h
theta = (pi/(2*h))*(j-1);% Pi /2*h
phi = (pi/h)*(i-1); % 2*Pi / w
a = r*cos(theta);
x = round(a*cos(phi)+ r +0.5);
y = round(a*sin(phi)+ r +0.5);
if sanityCheckFlip(x,y,w,h)==true
%arg = [theta, phi, a, cos(phi), x,y];
%disp(arg);
op ( h-j +1, (2*h)-i+1, :) = img(y, x, :);

end
 
end
end
 
 
end
function isTrue = sanityCheckFlip(x,y, w, h)
if isnan(x) || isnan (y)
isTrue = false;
return;
end
 
if (x>=1) && (x <=w)
if (y>=1) && (y <= h)
isTrue = true;
else
isTrue = false;
return;
end
else
isTrue = false;
return;
end
 
end

