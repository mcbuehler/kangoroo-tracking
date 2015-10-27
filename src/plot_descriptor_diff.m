[X,Y] = get_training_set();

m = size(X,1);
% Y'
% 
% sim = []
% nonsim = []
% for i = 1 : m
%    if Y(i) == 1
%        plot(1:128,X(i,:),'g')
%        sim = [sim; X(i,:)];
%        z = sum(X(i,:) == zeros(1,128));
% %        fprintf('similar zeros: %d\n',z)
%        
%    else
%        plot(1:128,X(i,:),'r')
%        nonsim = [nonsim; X(i,:)];
%        z = sum(X(i,:) == zeros(1,128));
%        fprintf('nonsimilar zeros: %d\n',z)
%    end
% end
% 
% sum(sim == zeros(size(sim)));
% sum(nonsim == zeros(size(nonsim)));

hold off 
hold on;
norms = zeros(m,1);
space = 0:150;
for i = 1 : m
    norms(i) = norm(X(i));
    if Y(i) == 1
        plot(i,norms(i),'*g');
    else
        plot(i,norms(i),'*r')
    end
end

norms


% s1 = subplot(1,2,1);
% axis equal
% histogram(sim,128);
% s2 = subplot(1,2,2);
% histogram(nonsim,128);
% linkaxes([s1 s2],'xy');
% 
% sim
% hold off
% length(find(sim))/size(sim,1)
% length(find(nonsim))/size(nonsim,1)
