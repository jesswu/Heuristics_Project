function [solution, bestX] = SA(xInitial, tInitial, alpha, beta, mInitial, maxTime, const)

% X0 or xInitial is the initial solution
% bestX is the best solution
% T0 or tInitial is the initial temperature
% alpha is the cooling rate
% beta is a constant
% mInitial represents the time until the next parameter update
% maxTime is the maximum total time for annealing process
% Time refers to the number of cost function evaluations performed
    
    global iter;

    T = tInitial;
    curX = xInitial;
    bestX = xInitial; % bestX is the best solution seen so far
    curCost = costSAT(curX, const);
    bestCost = curCost; 
    time = 0;
    M = mInitial;
    

    iter = 0;
    solution = zeros(maxTime+1,3);
    solution(iter+1,:)= [iter curCost bestCost];

    while time < maxTime
        [curX, curCost, bestX, bestCost, T, M] = Metropolis(curX, curCost, bestX, bestCost, T, M);
        time = time + M;
        T = alpha * T; % Update T after M iterations
        M = beta * M;
    end
    
    

    function [curX, curCost, bestX, bestCost, T, M] = Metropolis(curX, curCost, bestX, bestCost, T, M)
        M1=M;
        while M1 > 0
            newX = neighbor(curX);
            newCost = costSAT(newX, const);
            deltaCost = (newCost - curCost);

            if  deltaCost < 0 %if it is a downhill move
                curX = newX;
                curCost = newCost; %CORRECTION

                if newCost < bestCost
                    bestX = newX;
                    bestCost = newCost; % CORRECTION 
                end
            else %else it's a uphill move  
                if (rand() < exp(-deltaCost/ T))
                    curX = newX;
                    curCost = newCost; % CORRECTION 
                end
            end

            iter = iter + 1;
            solution(iter+1,:)= [iter curCost bestCost];
            M1 = M1 - 1;

         end
    end

    

end
    
