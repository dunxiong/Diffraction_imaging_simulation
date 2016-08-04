function out=SnpPhaseUnwrap(phase,interval,noise)
% out=SnpPhaseUnwrap(phase,interval,noise)
% this function is accord Miguel Arevallio Herraez's paper
% "Fast two-dimensional phase-unwrapping algorithmbased on sorting by reliability 
% followinga noncontinuous path" 2002,Applied optics

R = zeros(size(phase));
R(2:end-1,2:end-1) = PixelReliability(phase,interval,noise);%calculate the Pixel Reliability accoding second difference 

RH=R(1:end,1:end-1)+R(1:end,2:end);
RV=R(1:end-1,1:end)+R(2:end,1:end);

%sort RH and RV
dim=size(RH);
RHV=[RH(:);RV(:)];
[~,index] = sort(RHV,'descend');
group=zeros(size(R));

flag=1;
for p=1:1:2*dim(1)*dim(2)
    % find which one to unwrap now
    if index(p) > dim(1)*dim(2)
        n_index=index(p) - dim(1)*dim(2);
        i = mod(n_index-1,dim(2));
        j = floor((n_index-1)/dim(2));
        i1=i+1;
        j1=j+1;
        i2=i+2;
        j2=j+1;
    else
        n_index=index(p) ;
        i = mod(n_index-1,dim(1));
        j = floor((n_index-1)/dim(1));
        i1=i+1;
        j1=j+1;
        i2=i+1;
        j2=j+2;
    end
    %unwrap accord the group, first time there is no group
    if group(i1,j1)==0 && group(i2,j2)==0
        %unwrap
        error=phase(i1,j1)-phase(i2,j2);
        if abs(error)>interval-noise
            phase(i1,j1)= phase(i1,j1)-interval*round(error/interval);
        end
        %set group
        group(i1,j1)=flag;
        group(i2,j2)=flag;
        flag=flag+1;
    elseif group(i1,j1)~=0 && group(i2,j2)==0
        %unwrap
        error=phase(i2,j2)-phase(i1,j1);
        if abs(error)>interval-noise 
            phase(i2,j2)= phase(i2,j2)-interval*round((error)/interval);
        end
        %set group
        group(i2,j2)=group(i1,j1);
    elseif group(i1,j1)==0 && group(i2,j2)~=0
        %unwrap
        error=phase(i1,j1)-phase(i2,j2);
        if abs(error)>interval-noise
            phase(i1,j1)= phase(i1,j1)-interval*round((error)/interval);
        end
        %set group
        group(i1,j1)=group(i2,j2);
    elseif group(i1,j1)==group(i2,j2) && group(i1,j1)~=0
        % nothing
    else
        %unwrap
        error=phase(i1,j1)-phase(i2,j2);
        if abs(error)>interval-noise
            phase(group==group(i1,j1)) = phase(group==group(i1,j1))-interval*round((error)/interval);
        end
        %set group
        group(group==group(i1,j1))=group(i2,j2);
    end
end
out = phase; %output
end


function R = PixelReliability(in,interval,noise)
%R = PixelReliability(in,interval,noise) 
%calculate the Pixel Reliability accoding second difference 

H = RemoveStep(in(1:1:end-2,2:1:end-1) - in(2:1:end-1,2:1:end-1), interval, noise)...
    - RemoveStep(in(2:1:end-1,2:1:end-1) - in(3:1:end,2:1:end-1), interval, noise);
V = RemoveStep(in(2:1:end-1,1:1:end-2) - in(2:1:end-1,2:1:end-1), interval, noise)...
    - RemoveStep(in(2:1:end-1,2:1:end-1) - in(2:1:end-1,3:1:end), interval, noise);
D1 = RemoveStep(in(1:1:end-2,1:1:end-2) - in(2:1:end-1,2:1:end-1), interval, noise)...
    - RemoveStep(in(2:1:end-1,2:1:end-1) - in(3:1:end,3:1:end), interval, noise);
D2 = RemoveStep(in(1:1:end-2,3:1:end) - in(2:1:end-1,2:1:end-1), interval, noise)...
    - RemoveStep(in(2:1:end-1,2:1:end-1) - in(3:1:end,1:1:end-2), interval, noise);
R = 1./sqrt(H.^2+V.^2+D1.^2+D2.^2);

end

function out = RemoveStep(data,interval,noise)
%remove the difference caused by wrap
%noise is the wrap error
out = data;
temporary = (abs(data)-interval).*(abs(data))./(data+1e-18);
out(abs(data) > (interval-noise))= temporary(abs(data) > (interval-noise));

end


