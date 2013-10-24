%% tabuSAT.m
% Written by Brandon Bass
% Last edited: 10/24/2013

% Purpose: Perform Tabu Search algorithm for 3 SAT constraints in constraints.m

% Input parameters:
% constraints.m

% Output:
% Solutions_Tabu, which is a structure containing 
% sCur, sBest, AL, and costCur for each iteration and each simulation

% Functions:
% neighborhood_Tabu.m
% costSAT.m

clear
clc
close all

% % Generate constraints
% constraints = load('uf200-01.txt');
% constraints = vertcat(constraints, load('uf200-02.txt'));
% constraints = vertcat(constraints,load('uf200-03.txt'));
% constraints = vertcat(constraints,load('uf200-04.txt'));
% constraints = vertcat(constraints,load('uf200-05.txt'));
% constraints = vertcat(constraints,load('uf200-06.txt'));
% constraints = vertcat(constraints,load('uf200-07.txt'));
% constraints = vertcat(constraints,load('uf200-08.txt'));
% constraints = vertcat(constraints,load('uf200-09.txt'));
% constraints = vertcat(constraints,load('uf200-10.txt'));
% constraints(:,4) = [];
% save('constraints', 'constraints');
load constraints

% Parameters
numDims = 200;
numIter = 100;
m = 3; % taboo retention time
numSims = 1;

% Generate xInitials
p = 0.5;
xInitial = rand(numSims, numDims);
xInitial(xInitial<=p) = 0;
xInitial(xInitial>p) = 1;




% Initialize tabuList, Aspiration level, tabuCounter
tabuList = []; % tabuList will be a column vector containing indices which are taboo to flip
AL = [];
tabuCounter = 0;



for w = 1:numSims
    
    % First run
    ii = 1;
    AL = costSAT(xInitial(w,:), constraints);
    costCur = AL;
    sCur = xInitial(w,:);
    sBest = xInitial(w,:);
    Solutions_Tabu(w).sCur(ii,:) = sCur;
    Solutions_Tabu(w).sBest(ii,:) = sBest;
    Solutions_Tabu(w).AL(ii,1) = AL;
    Solutions_Tabu(w).costCur(ii,1) = costCur;
    
    %tabuList = vertcat(tabuList, sBest);
    ii = 2;
    while ii <= numIter
        
        if tabuCounter == m
            tabuCounter = 0;
            tabuList(1) = [];
        end
        
        sTest = neighborhood_Tabu(sCur); % create neighborhood from sCur
        [sortedFitness, fitness_idx] = sort(costSAT(sTest, constraints), 'ascend'); % evaluate cost of neighborhood and find the best solution
        
        % check if best answers are in tabu list
        % This method finds the index that is different from sCur.  This
        % will be what is stored in tabuList
        indexChanged = find(sTest(1,:)~= sCur);
        tabuCheck = ismember(indexChanged, tabuList);
        
        if tabuCheck == 0 % if not in tabu list
            
            sCur = sTest(1,:); % set sCur to best value
            costCur = sortedFitness(1); % set costCur to best fitness
            tabuList = vertcat(tabuList, indexChanged); % add index changed to tabuList
            
            if costCur < AL  % if costCur is better than AL
                AL = costCur;  % update AL
                sBest = sCur;  % update sBest
            end
            
        else % if answer is in the tabu list
            
            if sortedFitness(1) < AL % if the best fitness is better than the AL
                % ACCEPT TABU MOVE
                
                sCur = sTest(1,:);
                costCur = sortedFitness(1);
                tabuList = vertcat(tabuList, indexChanged);
                AL = costCur;
                sBest = sCur;
            else
                % Test if next best entries are in tabu list until you
                % find one that is not in the tabu list
                
                jj = 2;
                indexChanged = find(sTest(jj,:)~= sCur);
                while (ismember(indexChanged, tabuList) == 1)
                    jj = jj + 1;
                    indexChanged = find(sTest(jj,:)~= sCur);
                end
                
                % Once found, update sCur, costCur, tabuList
                sCur = sTest(jj,:);
                costCur = sortedFitness(jj);
                tabuList = vertcat(tabuList, indexChanged);
            end
        end
        
        Solutions_Tabu(w).sCur(ii,:) = sCur;
        Solutions_Tabu(w).sBest(ii,:) = sBest;
        Solutions_Tabu(w).AL(ii,1) = AL;
        Solutions_Tabu(w).costCur(ii,1) = costCur;
        ii = ii + 1;
        tabuCounter = tabuCounter + 1;
    end
    fprintf('Simulation %g \n', w)
    
end
