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

