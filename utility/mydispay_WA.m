function Out=mydispay_WA(In,flag,is_log)
%used for 4D display on a 2D plane
%set defauts
if exist('flag', 'var')~=1, flag=0;  end
if exist('is_log', 'var')~=1, is_log=0;  end
% set vison mode
In=abs(In);
if flag==1
    In=shiftdim(In,2);
end
% vison
dim=size(In);
m=linspace(1,dim(3),11);
n=linspace(1,dim(4),11);
Out=zeros(dim(1)*length(m),dim(2)*length(n));
for i=1:1:length(m)
    for j=1:1:length(n)
        x_offset=(i-1)*dim(1);
        y_offset=(j-1)*dim(2);
        Out(x_offset+1:x_offset+dim(1),y_offset+1:y_offset+dim(2))=In(:,:,m(i),n(j));
    end
end
if is_log==1
   figure,imshow(log((Out)),[])
else
   figure,imshow(((Out)),[]) 
end