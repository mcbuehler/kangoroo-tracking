%Create rect(x y width height) surrounding Array of x and y coordinates
%  function test
% % getRect([1;3;2;4], [2;1;4;3])
% getRect()
function val = CreateRect(X,Y)

lowestX = 1000000;
lowestY = 1000000;
highestX = 0;
highestY = 0;

for i = 1:size(X)
   if X(i) < lowestX 
       lowestX = X(i);
   end
   if X(i) > highestX
       highestX = X(i);
   end
   if Y(i) < lowestY 
       lowestY = Y(i);
   end
   if Y(i) > highestY
       highestY = Y(i);
   end
end

val = [lowestX lowestY (highestX-lowestX) (highestY-lowestY)];
