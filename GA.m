function [solution, sbest] = GA(Xinitial, popsize, maxGen, pCrossover, pMutation, constraints)

solution = zeros(maxGen,3);
sbest = zeros(maxGen,200);
currentPop = Xinitial; 
fit = zeros(1,popsize);
for i = 1:popsize
fit(i) = costSAT(currentPop(i,:),constraints);
end

for i = 1:maxGen
solution(i,:) = [i, mean(fit), max(fit)];
children = zeros(20,200);
for j = 1:10
[parent1, parent2] = selection_R(currentPop,fit);
[children(j,:),children(j+10,:)] = crossover(parent1,parent2,pCrossover);
end

for j = 1:20
children(j,:) = mutation(children(j,:),pMutation);
end

childFit = zeros(1,20);
for j = 1:20
childFit(j) = costSAT(children(j,:),constraints);
end

indexWeak = find(childFit==min(childFit),1);
indexStrong = find(fit==max(fit),1);
children(indexWeak,:) = currentPop(indexStrong,:);
currentPop = children;

for j = 1:popsize
fit(j) = costSAT(currentPop(j,:),constraints);
end


sbest(i,1:200) = currentPop(find(fit==max(fit),1),:);

end
end


function [child1, child2] = crossover(parent1,parent2,pCrossover)
if (rand()<=pCrossover)
cross = ceil(rand()*200);
child1 = cat(2,parent1(1:cross),parent2(cross+1:200));
child2 = cat(2,parent2(1:cross),parent1(cross+1:200));
else
child1 = parent1;
child2 = parent2;
end
end

function [child] = mutation(s, pMutation)
child = s;
for i = 1:length(s)
if (rand()<=pMutation)
child(i) = 1-child(i);
end
end
end


function [parent1,parent2] = selection_R(population,fit)
%fitness based probability selection
prob = cumsum(fit/sum(fit));
select1 = rand();
index1 = 0;
for i = 1:length(population)
if (index1==0 && select1<prob(i))
index1 = i;
end
end
parent1 = population(index1,:);

index2 = index1;
while index2==index1
select2 = rand();
tmp = 0;
for i = 1:length(population)
if (tmp==0 && select2<prob(i))
tmp = i;
end
end
index2 = tmp;
end
parent2 = population(index2,:);	
end


function [parent1,parent2] = selection_new(population,fit)
%rank based probability selection
[sort_fit, index] = sort(fit,'descend');
population = population(index,:);
prob = cumsum(index/sum(index));

select1 = rand();
index1 = 0;
for i = 1:length(population)
if (index1==0 && select1<prob(i))
index1 = i;
end
end
parent1 = population(index1,:);

index2 = index1;
while index2==index1
select2 = rand();
tmp = 0;
for i = 1:length(population)
if (tmp==0 && select2<prob(i))
tmp = i;
end
end
index2 = tmp;
end
parent2 = population(index2,:);	
end
