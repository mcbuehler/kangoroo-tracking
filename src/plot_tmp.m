function plot_tmp(I,X1,Y1,X2,Y2)

imshow(I);
hold on;
% plot(X1,Y1,'-b','markersize',10)

l = length(X1)
for i = 1 : l
    plot([X1(i) X2(i)], [Y1(i), Y2(i)],'-b')
    plot(X1(i),Y1(i),'*r','markersize',5)
	plot(X2(i),Y2(i),'*g','markersize',5)
end
hold off