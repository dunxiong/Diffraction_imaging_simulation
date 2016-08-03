function out = getphase(in)
%out = getphase(in)
%used for get the phase with a range of [0 2pi]
real_in = real(in);
imag_in = imag(in);

out = atan(imag_in./(real_in+1e-18));

out(real_in<0 & imag_in>0)=pi+out(real_in<0 & imag_in>0);
out(real_in<0 & imag_in<0)=pi+out(real_in<0 & imag_in<0);
out(real_in>0 & imag_in<0)=2*pi+out(real_in>0 & imag_in<0);