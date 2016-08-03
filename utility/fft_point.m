function [out]=fft_point(in,a,M,N,fx,fy)

[nr,nc] = size(in);

% Set defaults
if exist('fx', 'var')~=1, fx=0;  end
if exist('fy', 'var')~=1, fy=0; end
if fix(100*a)~=100*a
    error('the slice should only small keep two decimal');
end
noc=100*a*fy;
nor=100*a*fx;
%calculate use matrix Operation

kernc=exp((-1i*2*pi/(100*N))*((0:nc-1).' - floor(nc/2))*(noc));
kernr=exp((-1i*2*pi/(100*M))*((nor)*((0:nr-1) - floor(nr/2))));

out=kernr*in*kernc;
