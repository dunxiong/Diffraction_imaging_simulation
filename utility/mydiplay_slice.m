function Out=mydiplay_slice(In,a)
% interp of complex is not accurate
dim=size(In);

x=(0:1:dim(3)-1)-floor(dim(3)/2);
y=(0:1:dim(4)-1)-floor(dim(4)/2);
u=(0:1:dim(1)-1)-floor(dim(1)/2);
v=(0:1:dim(2)-1)-floor(dim(2)/2);

[y,x]=meshgrid(x,y);
[v,u]=meshgrid(u,v);
u1=a.*x;
v1=a.*y;
p_min=floor(u1);
p_max=ceil(u1);
q_min=floor(v1);
q_max=ceil(v1);
Out=zeros(size(x));
offset=floor(dim(1)/2)+1;

for i=1:1:dim(3)
    for j=1:1:dim(4)
        z=squeeze(In(:,:,i,j));
        if p_min(i,j)<-floor(dim(1)/2)
            Out(i,j)=0;
            break
        end
        if q_min(i,j)<-floor(dim(2)/2)
            Out(i,j)=0;
            break
        end
        if p_max(i,j)>floor(dim(1)/2)-1
            Out(i,j)=0;
            break
        end
        if q_max(i,j)>floor(dim(2)/2)-1
            Out(i,j)=0;
            break
        end
        if p_min(i,j)==p_max(i,j) && p_min(i,j)>-floor(dim(1)/2)
            p_min(i,j)=p_min(i,j)-1;
        end
        if  p_min(i,j)==p_max(i,j) && p_min(i,j)==-floor(dim(1)/2)
            p_max(i,j)=p_max(i,j)+1;
        end
        if q_min(i,j)==q_max(i,j) && q_min(i,j)>-floor(dim(2)/2)
            q_min(i,j)=q_min(i,j)-1;
        end
        if  q_min(i,j)==q_max(i,j) && q_min(i,j)==-floor(dim(2)/2)
            q_max(i,j)=q_max(i,j)+1;
        end
        x1=u(p_min(i,j)+offset:p_max(i,j)+offset,q_min(i,j)+offset:q_max(i,j)+offset);
        y1=v(p_min(i,j)+offset:p_max(i,j)+offset,q_min(i,j)+offset:q_max(i,j)+offset);
        z1=z(p_min(i,j)+offset:p_max(i,j)+offset,q_min(i,j)+offset:q_max(i,j)+offset);
        Out(i,j)=interp2(y1,x1,z1,v1(i,j),u1(i,j));
        
    end
end


