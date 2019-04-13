clc

subplot(122);
Q=imread('buildingOP.jpg');
imshow(Q);
title('OPENCV')
I=imread('building.jpg');
I=I(:,:,1);
subplot(121);
imshow(I);
title('MATLAB')
hold on


[m,n]=size(I);            
I=double(I);
R=zeros(m,n);
A=[];
B=[];

T=30000;
for i=3:m-2
    for j=3:n-2
        select=[0 1;1 1;1 0;1 -1];
        neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1;0 0];
        min=inf;
        sum=0;
        for k=1:4
            for l=1:9
                ii=i+neighbour(l,1);
                jj=j+neighbour(l,2);
                p=ii+select(k,1);
                q=jj+select(k,2);
                delta=I(ii,jj)-I(p,q);
                deltadouble=delta.^2;
                sum=sum+deltadouble;
            end
            if sum<=min
                min=sum;
            end
        end
        R(i,j)=min;
        if R(i,j)<T
           R(i,j)=0;  %%阈值处理
        end
    end
end

%%非极大值抑制
neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1;0 0];
for i=2:m-1
    for j=2:n-1
        for k=1:8
            if R(i,j)<R(i+neighbour(k,1),j+neighbour(k,2))
                R(i,j)=0;
            end
        end
    end
end

for i=1:m
    for j=1:n
        if R(i,j)~=0
           A=[A,i];
           B=[B,j];
        end
    end
end


plot(B,A,'or');