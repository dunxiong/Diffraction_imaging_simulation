function out=mutual_cal(z,bound,M,N)

dim=size(z);

if exist('M', 'var')~=1, M=2*dim(1);  end
if exist('N', 'var')~=1, N=2*dim(2); end

% generate cordirate
x = linspace(-bound,bound,dim(1))';           % spatial coordinate: row vector
y = linspace(-bound,bound,dim(2));            % spatial coordinate: column vector
u = linspace(-2*bound,2*bound,M);           % spatial coordinate:  row vector
v = linspace(-2*bound,2*bound,N)';            % spatial coordinate: column vector

[x0,y0]=meshgrid(x,y);
%%
x1=bsxfun(@plus, repmat(x,[1 length(u)]),u/2);
y1=bsxfun(@plus, repmat(y,[length(v) 1]),v/2)';
x2=bsxfun(@minus, repmat(x,[1 length(u)]),u/2);
y2=bsxfun(@minus, repmat(y,[length(v) 1]),v/2)';

x1=x1(:);
y1=y1(:)';
x1=repmat(x1,[1 length(y1)]);
y1=repmat(y1,[length(x1) 1]);

x2=x2(:);
y2=y2(:)';
x2=repmat(x2,[1 length(y2)]);
y2=repmat(y2,[length(x2) 1]);

U1=interp2(x0,y0,z,y1,x1);
U1(abs(x1)>bound | abs(y1)>bound)=0;

U2=interp2(x0,y0,z,y2,x2);
U2(abs(x2)>bound | abs(y2)>bound)=0;
UU=U1.*conj(U2);
UU_real=real(UU);
UU_imag=imag(UU);
U_real=zeros(length(x),length(y),length(u),length(v));
U_imag=zeros(length(x),length(y),length(u),length(v));
clearvars -except U_real UU_real U_imag UU_imag x y u v 
x_dim=length(x);
y_dim=length(y);
for i=1:1:length(u)
    x_offset=(i-1)*x_dim;
    for j=1:1:length(v)
        tic
        y_offset=(j-1)*y_dim;
        U_real(:,:,i,j)=UU_real(x_offset+1:x_offset+x_dim,y_offset+1:y_offset+y_dim);
        U_imag(:,:,i,j)=UU_imag(x_offset+1:x_offset+x_dim,y_offset+1:y_offset+y_dim);
        toc
    end
end
out=U_real+U_imag.*1i;
