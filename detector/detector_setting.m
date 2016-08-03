function system=detector_setting(lambda,lambda0,f_0)
% this function used for detector set
% if using defferent detector, one need to change the corresding parameters
% input:
%      lambda--- the calculating wavelengths
%      lamda0--- the refenerce wavelength for the relife design of DOE
%      f_0--- the focus length of the DOE at the reference wavelength
% output: output is a structure
%      system.lambda---is the wavelength used for detector calculating
%      system.n---is the refraction index of the material of DOE substrate
%                 at the above wacelength
%      system.f--- is the approximate focus length of DOE at the above wavelength 
%      system.qe_b--is the quantum efficience of the blue detector at the above wavelength
%      system.qe_g--is the quantum efficience of the green detector at the above wavelength
%      system.qe_r--is the quantum efficience of the red detector at the above wavelength
%      system.PX--is the X direction sample position of the PSF at the detect plane
%      system.PY--is the Y direction sample position of the PSF at the detect plane


% fused silica glass info // DOE substrate
wave = [0.2 0.22 0.25 0.3 0.32 0.36 0.4 0.45 0.488 0.5 0.55 0.588 ...
    0.6 0.633 0.65 0.7 0.75 0.8 0.85 0.9]*1e-6;
n_idx = [1.55051 1.52845 1.50745 1.48779 1.48274 1.47529 1.47012 1.46557 ...
    1.46302 1.46233 1.46008 1.45860 1.45804 1.45702 1.45653 1.45529 ...
    1.45424 1.45332 1.45250 1.45175];

% calculating the refraction index and focus length at designed wavelength
n_lambda = interp1(wave, n_idx, lambda);
f_lambda = f_0*lambda0./lambda; 

% Read QE of the RGB CMOS sensor and interpolation, random sensor
QE_B = load('DetectorParameter\QE_B.txt');
qe_b = interp1(QE_B(:,1)*1e-9, QE_B(:,2), lambda, 'linear', 'extrap');
QE_G = load('DetectorParameter\QE_G.txt');
qe_g = interp1(QE_G(:,1)*1e-9, QE_G(:,2), lambda, 'linear', 'extrap');
QE_R = load('DetectorParameter\QE_R.txt');
qe_r = interp1(QE_R(:,1)*1e-9, QE_R(:,2), lambda, 'linear', 'extrap');

% set PSF sampling on the sensor
pitch = 5e-6;% sensor pixel pitch, Canon 70D
k_width = 101;% pixel numbers of kernel width, must be odd
k_height = 101;% pixel numbers of kernel height, must be odd
pitch_x = pitch*(-(k_width - 1)/2 : (k_width - 1)/2);
pitch_y = pitch*(-(k_height - 1)/2 : (k_height - 1)/2);
[PX, PY] = meshgrid(pitch_x, pitch_y);

% for return
system.lambda=lambda;
system.n=n_lambda;
system.f=f_lambda;
system.qe_b=qe_b;
system.qe_g=qe_g;
system.qe_r=qe_r;
system.PX=PX;
system.PY=PY;
system.pitch=pitch;











