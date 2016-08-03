function [Layer_P,M_P]=generate_binary_mask(TransmissionProfile,varargin)
% generate patterns for L-Edit
% input:
%      Phaseprofile:the transmission profile, matrix style
%      varargin: step--the binary step,one step means two levels, the defaut is 4
%                margin--the bunber of margin pixel, the default is 0
%                group_aligment--the flag of if using group aligment mask, 0 means not use, 1 means use, the size of the group aligment mask is 200*200
%                cir_flag--the flag if restricing the effect area of phase profile to a circle,0 means not, 1 means yes defaut is 1 
% output
%      Layer_P: the phase profile of the enter continuous transmission profile 
%      M_P: the phase profile of the out binary transmission profile
%      they have been normaled to [0 1] 
% xiong dun, 2016/05/30
% revise:
%

%setting parameters 
if isempty(varargin)
   step=4;
   margin=0;
   group_aligment=0;
   cir_flag=0;
else
    switch nargin
        case 2
             step=cell2mat(varargin(1));
             margin=0;
             group_aligment=0;
             cir_flag=0;
        case 3
             step=cell2mat(varargin(1));
             margin=cell2mat(varargin(2));
             group_aligment=0;
             cir_flag=0;
        case 4
             step=cell2mat(varargin(1));
             margin=cell2mat(varargin(2));
             group_aligment=cell2mat(varargin(3));
             cir_flag=0;
        case 5
             step=cell2mat(varargin(1));
             margin=cell2mat(varargin(2));
             group_aligment=cell2mat(varargin(3));
             cir_flag=cell2mat(varargin(4));
        otherwise
             disp('the number of varargin should not biger than 2')
             return
    end
end   

%establish the storage file for mask
storagefilename='0_MyMask';
if exist(storagefilename, 'dir') == 0
    mkdir(storagefilename);
end

%Phase profile size
[row, col, ch] = size(TransmissionProfile); 

% coordinates
x = (1:col) - (col + 1)/2;
y = (1:row) - (row + 1)/2;
Rmax = min(row, col)/2;
[X, Y] = meshgrid(x, y);
[~, R] = cart2pol(X, Y); % treansfer to pole 

Layer_P=zeros(row + 2 * margin, col + 2 * margin,ch);
M_P=Layer_P;
for i = 1:ch
    fprintf('Generating Masks for Element %d\n', i);
    
    Mask = zeros(row + 2 * margin, col + 2 * margin);% masks for fabrication
    M = zeros(row + 2 * margin, col + 2 * margin);% reconstructed binary pattern, for verification
    
    Layer = angle(TransmissionProfile(:,:,i)) + pi;
    % normalize to [0, 1]
    Layer = Layer - min(Layer(:));
    Layer = Layer / max(Layer(:));
    Layer(Layer == 1) = 1 - eps;% Important! To avoid false zeros in mod
    % is using circle aperture
    if ~cir_flag
    else
      Layer(R > Rmax) = 1;% white background
    end
    
%     figure,imshow(Layer);
    str = ['.\' storagefilename '\User_Element' num2str(i) '-Continuous' '.png'];
    imwrite(Layer, str);
    Layer_P(margin+1:row+margin, margin+1:col+margin,i)=Layer;
    
    for j = 1: step
        fprintf('Generating layer %d Mask for Element %d\n',j,i);
        threshold = 1/2^j;
        Mask(margin+1:row+margin, margin+1:col+margin) = mod(Layer, 1/2^(j-1)) >= threshold;
        M = M + (1/2^(j)).*Mask;
        % is using circle aperture 
        if ~cir_flag
        else
           Mask(R > Rmax) = 1;% white background
        end
        % is using the group aligment
        if ~group_aligment
        else
           Mask(1:200, 1:200) = 0;% write a square at the top left corner
           Mask(end-200:end, end-200:end) = 0;% write a square at the bottom right corner
        end
%         figure,imshow(Mask);
        str = ['.\' storagefilename '\User_Element' num2str(i) '_Level' num2str(2.^j) '.bmp'];% must save as bmp
        imwrite(Mask, str);
    end
    
    str = ['.\' storagefilename '\User_Element' num2str(i) '_ReconPhase' '-' num2str(2^j) 'levels.png'];
    % is using circle aperture
    if ~cir_flag
    else
      M(R > Rmax) = 1;% white background
    end
%     figure,imshow(M);
    imwrite(M, str);
    M_P(:,:,i)=M;
    
    % verification
%     figure,bar(M(:, round(col/2)));
%     xlim([0 col]);
%     ylim([-0.1 1.1]);
%     hold on;
%     plot(Layer(:, round(col/2)),'r-');
    
end

