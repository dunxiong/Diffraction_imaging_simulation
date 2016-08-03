function [out]=fft_DOE(in,factor,noc,nor)
%[out]=fft_DOE(in,factor,noc,nor)
%this fuction is used for fft calculation of DOE with finite aperture
%we can use it to improve the sample rate
%the opration don't have scale, it is the same as the diffraction equaltion
%input:
%     in      ---- the input image
%     factor  ---- the upsampe ratio
%     noc,noc ---- the size of the output fft image
%outpu:
%     out     ---- outpu image
% author by Xiong Dun Jul/13/2016

[nr,nc] = size(in);

% Set defaults
if exist('factor', 'var')~=1, factor=1;  end
if exist('noc', 'var')~=1, noc=nc;  end
if exist('nor', 'var')~=1, nor=nr; end

% check input
if noc > round(nc*factor) || nor > round(nr*factor)
   error('the output size must not larger than the upsampe ratio mutilple orgin size!');
end

%calculate use matrix Operation
dftshift_c = fix(noc/2);
dftshift_r = fix(nor/2);
kernc=exp((-1i*2*pi/(round(nc * factor)))*( (0:nc-1).' - floor(nc/2))*((0:noc-1)-dftshift_c));
kernr=exp((-1i*2*pi/(round(nr * factor)))*( (0:nor-1).'-dftshift_r)*( (0:nr-1) - floor(nr/2) ));

out=kernr*in*kernc;
