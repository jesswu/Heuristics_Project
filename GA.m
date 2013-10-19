function [solution, sbest] = GA(Xinitial, popsize, maxGen, pCrossover, pMutation)

solution = zeros(maxGen,3);
sbest = zeros(maxGen,2);
currentPop = Xinitial; 
fit = zeros(1,popsize);
for i = 1:popsize
fit(i) = fitness(currentPop(i,:));
end

for i = 1:maxGen

children = zeros(20,14);
for j = 1:10
[parent1, parent2] = selection_R(currentPop,fit);
[children(j,:),children(j+10,:)] = crossover(parent1,parent2,pCrossover);
end

for j = 1:20
children(j,:) = mutation(children(j,:),pMutation);
end

childFit = zeros(1,20);
for j = 1:20
childFit(j) = fitness(children(j,:));
end

indexWeak = find(childFit==min(childFit),1);
indexStrong = find(fit==max(fit),1);
children(indexWeak,:) = currentPop(indexStrong,:);
currentPop = children;

for j = 1:popsize
fit(j) = fitness(currentPop(j,:));
end

sbest(i,1) = bin2dec(strcat(num2str(currentPop(find(fit==max(fit),1),1:7))));
sbest(i,2) = bin2dec(strcat(num2str(currentPop(find(fit==max(fit),1),8:14))));
solution(i,:) = [i, mean(fit), max(fit)];
end
end

pCrossover = .9;
pMutation = .05;
popsize = 20;
maxGen = 50;
Xinitial = round(rand(20,14));	
