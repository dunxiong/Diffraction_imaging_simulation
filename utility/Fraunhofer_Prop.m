function [Uout, x2, y2] = Fraunhofer_Prop(Uin, wvl, d1, Dz, factor, OutSize)
%[Uout, x2, y2] = fraunhofer_prop(Uin, wvl, d1, Dz, factor, OutSize) 
%Fraunhofer propagation of light
% Input:
%      Uin     --- input optical field
%      wvl     --- wavelength
%      d1      --- the sample distance in object-plane
%      Dz      --- the distance between the observation-plane and object-plane
%      factor  --- the upsampe ratio in observation-plane, the larger the
% factor is, the more detail can see in the observation-plane
%      OutSize --- the sample number in observation plane
% Output:
%      Uout    --- output optical field
%      x2,y2   --- the coordinate of the output optical field
% author by Xiong Dun Jul/13/2016

[nr,nc] = size(Uin);

% change the input optical field to square
Uin_new = zeros(max(nr,nc),max(nr,nc));
if nr > nc
    offset = floor(nr-nc) / 2;
    Uin_new(:,offset+1:nc+offset) = Uin;
else
    offset = floor(nr-nc) / 2;
    Uin_new(offset+1:nr+offset,:) = Uin;
end

k = 2*pi / wvl;
N = size(Uin_new, 1);

%set defauts
if exist('factor', 'var')~=1, factor=1;  end
if exist('OutSize', 'var')~=1, OutSize=N;  end

% chect input data
if OutSize > N*factor
    error('the out size shold not larger than the factor multiple orgin size')
end

% observation-plane coordinates
fX = ((0:OutSize-1) - floor(OutSize/2)) / (d1*round(N*factor));
[x2, y2] = meshgrid(wvl * Dz * fX);

% observation-plane field 
Uout = exp(1i*k/(2*Dz)*(x2.^2+y2.^2)) / (1i*wvl*Dz) .* fft_DOE(Uin_new,factor,OutSize,OutSize) .* d1.^2;



