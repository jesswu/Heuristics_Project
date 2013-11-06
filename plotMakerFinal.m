% This makes boxplots and avg best cost vs iteration plots for all 10 constraints

close all
clear
clc

%% Load in Solution structures
load('solutionSA.mat')
load('Solutions_Tabu.mat')
load('bestCost_GA')
GA1500iterations = load('GA1500iterations.mat'); 
GA1500iterations = GA1500iterations.t;

AL_vec = [];
for i = 1:10
    AL_vec = [];
    for k = 1:1500
        for j = 1:30
            AL_vec = vertcat(AL_vec, Solutions_Tabu(i).Sim(j).AL(k));
        end
        mean_ALvec = mean(AL_vec);
        meanAL_container(k) = mean_ALvec;
        AL_vec = [];
    end
    avgSolutions_Tabu(i).meanSolution = meanAL_container;
    meanAL_container = [];
end

% variable avgSolutions_Tabu contains the average solutions over 30
% iterations 

for i = 1:10
    figure(i)
    hold on
    plot(avgSolutions_Tabu(i).meanSolution)
    plot(solution{i}(:,3), 'r')
    plot(GA1500iterations(i,:), 'k')
    legend('Tabu', 'SA', 'GA')
end

%% Box plot creation
% We want to take the best value (last value) of every 
load('bestCostSA.mat') % SA

% Need to make a corresponding matrix for Tabu Search
bestALvec = [];
for i = 1:10
    for j = 1:30
        k = 1500;
        bestALvec = vertcat(bestALvec, Solutions_Tabu(i).Sim(j).AL(k));
    end
    bestAL(:,i) = bestALvec;
    bestALvec = [];
end
        

% Plot 10 boxplots of all algorithms
for i = 1:10
    figure(i+10)
    boxplot([bestAL(:,i), bestCost(:,i), bestCost_GA(:,i)], 'labels', {'Tabu', 'SA', 'GA'})
end

            
        
            
