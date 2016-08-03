function out=fft_slice(U,a)

dim=size(U);

x=(0:1:dim(3)-1)-floor(dim(3)/2);
y=(0:1:dim(4)-1)-floor(dim(4)/2);

[y,x]=meshgrid(x,y);
out=zeros(dim(3),dim(4));
for i=1:1:dim(3)
    for j=1:1:dim(4)
        z=squeeze(U(:,:,i,j));
        out(i,j)=fft_point(z,a,dim(3),dim(4),x(i,j),y(i,j));        
    end
end