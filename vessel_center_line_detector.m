function [lamdam] = vessel_center_line_detector(Image,s,line_type)
% function [lamdam] = vessel_center_line_detector(Image,s)
%
% Detects center lines (blood vessels)
%
%
% Arguments:    Image       - Input Image
%               s           - sigma value for gaussian filter
%               line_type   - -1 for dark lines in light background
%                              1 for bright lines in dark background
%                              0 for both type of lines
%
% Returns:      lamdam - the eigenvalues that belong to perpendicular 
%               eigenvectors with zero gradient.
% 
% Example:     [tri,hys]=HYSTERESIS3D(img,0.25,0.8,26)
%


% open image, convert to gray scale
I=im2double(rgb2gray(Image));

% create gaussian kernel (s=sigma)
g = fspecial('gaussian', [15 15], s);

% % 1st and 2nd order Gaussian Gradients
% [gx, gy] = gradient(g);
% [g2x, g2xy] = gradient(gx);
% [g2xy, g2y] = gradient(gy);

% % 1st and second order Image Gradients(convolution with gaussian
% % gradients)
% Ix=(s^2)*conv2(double(I),gx,'same');
% Iy=(s^2)*conv2(double(I),gy,'same');
% Ixx=(s^2)*conv2(double(I),g2x,'same');
% Iyy=(s^2)*conv2(double(I),g2y,'same');
% Ixy=conv2(double(I),g2xy,'same');

[Ix,Iy]=gaussgradient(I,s);
[Ixx,Ixy]=gaussgradient(Ix,s);
[Ixy,Iyy]=gaussgradient(Iy,s);

% Calculate max eigenvalues (lamdam) of Hessian matrix [Ixx Ixy; Ixy Iyy]
a=Ixx;b=Ixy;c=Iyy;
q=0.5*((a+c)+sign(a+c).*sqrt((a-c).^2+4*b.^2));
lamda1=q;
lamda2=(a.*c-b.^2)./q;
lamdam=max(lamda1,lamda2);

% Calculate eigenvectors (umx,umy) of lamdam 
umx=abs(b)./sqrt(b.^2+(lamdam-a).^2);
umy=sign(b).*(lamdam-a)./sqrt(b.^2+(lamdam-a).^2);

t=-(umx.*Ix+umy.*Iy)./(umx.^2.*Ixx+2*umx.*umy.*Ixy+umy.^2.*Iyy);

for y=1:size(umx,2)
    for x=1:size(umx,1)
        tumx=t(x,y)*umx(x,y);
        tumy=t(x,y)*umy(x,y);
        % if eigenvectors not perpendicular to center line
        if lamdam(x,y)*line_type>0 || (abs(tumx)>0.5 || abs(tumy)>0.5)
            % then dismiss this eigenvalue
            % by setting an invalid value
            lamdam(x,y)=line_type;
        end
    end
end
