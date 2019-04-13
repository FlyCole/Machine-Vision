clc

subplot(122);
Q=imread('buildingOP.jpg');
imshow(Q);
title('OPENCV');
I=imread('building.jpg');
I=I(:,:,1);
subplot(121);
imshow(I);
title('MATLAB');
hold on
[m,n]=size(I);            
I=double(I);
R=zeros(m,n);
a=[];
b=[];


w=fspecial('sobel');                %构造sobel矩阵
img_y=imfilter(I,w,'replicate');    %竖直方向的梯度
w=w';
img_x=imfilter(I,w,'replicate');    %水平方向的梯度
G=fspecial('gaussian',[3,3]);       %构造高斯矩阵
Ixsq=img_x.^2;                      %预构造自相关矩阵中系数A
Iysq=img_y.^2;                      %预构造自相关矩阵中系数B
IxIy=img_x.*img_y;                  %预构造自相关矩阵中系数C
A=imfilter(Ixsq,G,'replicate');     %构造矩阵中系数A
B=imfilter(Iysq,G,'replicate');     %构造矩阵中系数B
C=imfilter(IxIy,G,'replicate');     %构造矩阵中系数C
for i=1:m
    for j=1:n
        R(i,j)=A(i,j)*B(i,j)-C(i,j)^2-0.05*(A(i,j)+B(i,j))^2;
    end
end

T=700000000;
for i=1:m
    for j=1:n
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

%%选择非零点作为角点检测结果
for i=1:m
    for j=1:n
        if R(i,j)~=0
           a=[a,i];
           b=[b,j];
        end
    end
end


plot(b,a,'or');