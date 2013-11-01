%% tabuSAT.m
% Written by Brandon Bass
% Last edited: 11/1/2013

% Purpose: Perform Tabu Search algorithm for 3 SAT constraints in constraints.m

% Input parameters:
% constraints.m

% Output:
% Solutions_Tabu, which is a structure containing
% sCur, sBest, AL, and costCur for each iteration and each simulation
% with the format solutions(x).Sim(w).Parameters for x constraint scenarios and w simulations.  

% Functions:
% neighborhood_Tabu.m
% costSAT.m

clear
clc
close all

% % Generate constraints
constraintsStruct(1).constraints = load('uf200-01.txt');
constraintsStruct(2).constraints = load('uf200-02.txt');
constraintsStruct(3).constraints = load('uf200-03.txt');
constraintsStruct(4).constraints = load('uf200-04.txt');
constraintsStruct(5).constraints = load('uf200-05.txt');
constraintsStruct(6).constraints = load('uf200-06.txt');
constraintsStruct(7).constraints = load('uf200-07.txt');
constraintsStruct(8).constraints = load('uf200-08.txt');
constraintsStruct(9).constraints = load('uf200-09.txt');
constraintsStruct(10).constraints = load('uf200-10.txt');
for i =1:10
    constraintsStruct(i).constraints(:,4) = [];
end


% Parameters
numDims = 200;
numIter = 1500;
m = 25; % taboo retention time
numSims = 30;

% Generate xInitials
p = 0.5;
xInitial = rand(numSims, numDims);
xInitial(xInitial<=p) = 0;
xInitial(xInitial>p) = 1;




% Initialize tabuList, Aspiration level, tabuCounter
tabuList = []; % tabuList will be a column vector containing indices which are taboo to flip
AL = [];
tabuCounter = 0;

for x = 1:10
    constraints = constraintsStruct(x).constraints;
    tic
    for w = 1:numSims
        
        % First run
        ii = 1;
        AL = costSAT(xInitial(w,:), constraints);
        costCur = AL;
        sCur = xInitial(w,:);
        sBest = xInitial(w,:);
        Solutions_Tabu(x).Sim(w).sCur(ii,:) = sCur;
        Solutions_Tabu(x).Sim(w).sBest(ii,:) = sBest;
        Solutions_Tabu(x).Sim(w).AL(ii,1) = AL;
        Solutions_Tabu(x).Sim(w).costCur(ii,1) = costCur;
        
        %tabuList = vertcat(tabuList, sBest);
        ii = 2;
        while ii <= numIter
            
            %         if tabuCounter == m
            %             tabuCounter = 0;
            %             tabuList(1) = []
            %         end
            
            sTest = neighborhood_Tabu(sCur); % create neighborhood from sCur
            [sortedFitness, fitness_idx] = sort(costSAT(sTest, constraints), 'ascend'); % evaluate cost of neighborhood and find the best solution
            
            % check if best answers are in tabu list
            % This method finds the index that is different from sCur.  This
            % will be what is stored in tabuList
            indexChanged = find(sTest(fitness_idx(1),:)~= sCur);
            tabuCheck = ismember(indexChanged, tabuList);
            
            if tabuCheck == 0 % if not in tabu list
                
                sCur = sTest(fitness_idx(1),:); % set sCur to best value
                costCur = sortedFitness(1); % set costCur to best fitness
                
                tabuList(end+1,1) = indexChanged;
                %             tabuCounter = length(tabuList);
                %             if tabuCounter == m+1
                %                 %tabuCounter = 0;
                %                 tabuList(1) = [];
                %             end
                %tabuList = vertcat(tabuList, indexChanged); % add index changed to tabuList
                
                if costCur < AL  % if costCur is better than AL
                    AL = costCur;  % update AL
                    sBest = sCur;  % update sBest
                end
                
            else % if answer is in the tabu list
                
                if sortedFitness(1) < AL % if the best fitness is better than the AL
                    % ACCEPT TABU MOVE
                    
                    sCur = sTest(fitness_idx(1),:);
                    costCur = sortedFitness(1);
                    tabuList(end+1,1) = indexChanged;
                    %                 tabuCounter = length(tabuList);
                    %                 if tabuCounter == m+1
                    %                     %tabuCounter = 0;
                    %                     tabuList(1) = [];
                    %                 end
                    AL = costCur;
                    sBest = sCur;
                else
                    % Test if next best entries are in tabu list until you
                    % find one that is not in the tabu list
                    
                    jj = 2;
                    indexChanged = fitness_idx(jj);
                    %indexChanged = find(sTest(jj,:)~= sCur);
                    while (ismember(indexChanged, tabuList) == 1)
                        jj = jj + 1;
                        indexChanged = fitness_idx(jj);
                    end
                    
                    % Once found, update sCur, costCur, tabuList
                    sCur = sTest(indexChanged,:);
                    costCur = sortedFitness(jj);
                    
                    tabuList(end+1,1) = indexChanged;
                    %                 tabuCounter = length(tabuList);
                    %                 if tabuCounter == m +1
                    %                     %tabuCounter = 0;
                    %                     tabuList(1) = [];
                    %                 end
                    %tabuList = vertcat(tabuList, indexChanged);
                end
            end
            
            Solutions_Tabu(x).Sim(w).sCur(ii,:) = sCur;
            Solutions_Tabu(x).Sim(w).sBest(ii,:) = sBest;
            Solutions_Tabu(x).Sim(w).AL(ii,1) = AL;
            Solutions_Tabu(x).Sim(w).costCur(ii,1) = costCur;
            tabuCounter = length(tabuList);
            if tabuCounter == m +1
                %tabuCounter = 0;
                tabuList(1) = [];
            end
            ii = ii + 1;
            %tabuCounter = tabuCounter + 1;
            %fprintf('%s \n',tabuCounter)
        end
        fprintf('Simulation %g \n', w)
        
    end
    toc
end
