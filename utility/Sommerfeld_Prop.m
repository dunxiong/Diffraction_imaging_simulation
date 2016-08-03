function [Out, x2, y2] = Sommerfeld_Prop(Uin, wvl, d1, Dz, M, OutSize)
%[Out, x2, y2] = Sommerfeld_Prop(Uin, wvl, d1, Dz, M, OutSize)
%Sommerfeld propagation of light (one step)
% Input:
%      Uin     --- input optical field
%      wvl     --- wavelength
%      d1      --- the sample distance in object-plane
%      Dz      --- the distance between the observation-plane and object-plane
%      M       --- the calculation size in observation-plane
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

% ???????? ?????

%set defauts
if exist('M', 'var')~=1, M=2*N;  end
if exist('OutSize', 'var')~=1, OutSize=N;  end


% chect input data
if OutSize > M
    error('the out size shold not larger than the calculation size')
end

if M <= N
    error('the calcution size shold  larger than 1 times of the orgin size')
end

% source-plane coordinates
% [x1, y1] = meshgrid(((0:M-1)-floor(M/2)) * d1);

% generate blur fuction
% r = sqrt(x1.^2 + y1.^2 + Dz^2);
% blur_r = 1/(2*pi) * Dz * exp(1i*k*r)./r.^3 .* (1 - 1i*k*r);
% blur_r = 1/(4*pi) .* exp(1i*k*r)./r .* (Dz./r.^2.*(1-1i*k*r)-1i*k);
% blur_r = 1/(1i*2*wvl) .* exp(1i*k*r)./r .* (Dz./r+1);
% blur_r = 1/(1i*wvl) .* exp(1i*k*r)./r;

% calculate sommerfeld diffraction


%AS sample number
epsion = 0.01;
detx = 2*(Dz)*sqrt(1/epsion-1);
N_AS = round((detx/d1))+N;
%DIsample number
N_DI = N*ceil(d1/wvl * 2 * sin(atan(M*d1/Dz)));

if N_AS <=N_DI
   M = N_AS;
   if mod(M,2)==0
      M=M+1;
   end
   [fX, fY] = meshgrid(((0:M-1) - floor(M/2)) / (d1*M));
   H_blur=exp(1i * k * Dz .* sqrt(1-(wvl.*fX).^2-(wvl.*fY).^2));
   Out=ifft_DOE(fft_DOE(Uin_new, M/N, M, M).*d1.^2.*H_blur, 1, M, M).*(1/d1).^2;
   disp('AS')
   offset=floor(M/2);
   Out=Out(offset-floor(OutSize/2)+1:offset-floor(OutSize/2)+OutSize,offset-floor(OutSize/2)+1:offset-floor(OutSize/2)+OutSize);
else
   M = N_DI;
   if mod(M,2)==0
      M=M+1;
   end
   factor=M/N;
   d1=d1/factor;
   Uin = zeros(M);
   for  i = 1:factor
        for j = 1:factor
           Uin(i:factor:end,j:factor:end) = Uin_new;
        end
   end
   [x1, y1] = meshgrid(((0:M-1)-floor(M/2)) * d1);
   r = sqrt(x1.^2 + y1.^2 + Dz^2);
   blur_r = 1/(2*pi) * Dz * exp(1i*k*r)./r.^3 .* (1 - 1i*k*r);
   Out=ifft_DOE(fft_DOE(blur_r, 2, 2*M, 2*M).*d1.^2.*fft_DOE(Uin, 2, 2*M, 2*M).*d1.^2, 1, M, M).*(1/d1).^2;
   disp('DI')
   Out=Out(1:factor:end,1:factor:end);
end

% generate observation-plane coordinates
[x2, y2] = meshgrid(((0:OutSize-1)-floor(OutSize/2)) * d1 );



