function plot_tmp(I,X1,Y1,X2,Y2)

imshow(I); hold on;
X = X1-X2;
Y = Y1-Y2;

l = length(X)
for i = 1 : l
    plot([X1(i);X2(i)],[Y1(i);Y2(i)],'b-'); 
end

for i = 1 : l
    if X(i) < 0
        % green means goes right
        plot(X2(i),Y2(i),'g*')
    else
        % goes left
        plot(X2(i),Y2(i),'r*')
    end
end
hold off;
