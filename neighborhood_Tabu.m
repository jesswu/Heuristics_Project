function [ neighborhood ] = neighborhood_Tabu( s )
%neighborhood_Tabu.m is a neighborhood function for the binary tabu search
% for each element in vector s, it creates a new entry with one element
% flipped.


for ii = 1:length(s)
    snew = s;
    switch s(ii)
        case 0
            snew(ii) = 1;
        case 1
            snew(ii) = 0;
    end
    neighborhood(ii,:) = snew;
end



end
