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



function [solution, sbest] = GA(Xinitial, popsize, maxGen, pCrossover, pMutation, constraints)

solution = zeros(maxGen,3);
sbest = zeros(maxGen,200);
currentPop = Xinitial; 
fit = zeros(1,popsize);
for i = 1:popsize
fit(i) = -costSAT(currentPop(i,:),constraints);
end

for i = 1:maxGen
solution(i,:) = [i, mean(fit), max(fit)];
children = zeros(popsize,200);
for j = 1:popsize/2
[parent1, parent2] = selection_R(currentPop,fit);
[children(j,:),children(j+popsize/2,:)] = crossover(parent1,parent2,pCrossover);
end

for j = 1:popsize
children(j,:) = mutation(children(j,:),pMutation);
end

childFit = zeros(1,popsize);
for j = 1:popsize
childFit(j) = -costSAT(children(j,:),constraints);
end

%elitism
indexWeak = find(childFit==min(childFit),1);
indexStrong = find(fit==max(fit),1);
children(indexWeak,:) = currentPop(indexStrong,:);
currentPop = children;

for j = 1:popsize
fit(j) = -costSAT(currentPop(j,:),constraints);
end

sbest(i,1:200) = currentPop(find(fit==max(fit),1),:);

end
end


function [ f ] = costSAT( s, constraints )
% cost.m evaluates the cost based on constraints contained in the
% constraints matrix assignments in matrix s

% Variable Dictionary:
%
% Inputs
%
% constraints needs to be an R1xC1 matrix, with each index positive or
% negative, denoting whether the constraint is a binding or a 'not'
% decision. For a 3 SAT problem, C1 = 3. Each entries absolute value relates
% to the index in s. For our problem, constraints should be an 8600x3
% matrix
%
% s is an R2xC2 matrix, which can have as many rows as the user wishes to evaluate.
% Each row is a test answer.  the entries in s are 1 or 0.
%
% Outputs
%
% The output f is a R2x1 matrix containing the cost of each row of s. The
% cost is the number of unsatisfied constraints.
%
% Parameters
%
% L is a representation of whether the indices in uf20_01 are negating or
% not.  ie if ~4 3 5, L = 0 1 1, abs(uf20_01) = 4 3 5.
%
% Methodology
% costSAT goes through each entry in stest and sees whether it abides by
% the constraints in uf20_01.

[r,~] = size(s);
[r1, ~] = size(constraints);
absConstraints = abs(constraints);


L = constraints./absConstraints;
L(L==-1) = 0;

f = zeros(r,1);

for i = 1:r
stest = s(i,:);
test = stest(absConstraints);
f(i,1) = r1 - numel(find(any(test==L, 2))); % find all entries with any 1's, which shows the constraint is satisfied.  Subtract from total # entries to get number unsatisfied constraints
    
    
end

end
