%% CONSTANTS
P = 0.5; % chance to hit
SHOTCOUNT = 100; % 100 shots in a game as stated in problem description
HITS = 5; % how many hits are expected (= m in solution description)

%% Script for the recursion
analyticSolution = analyticsolve(SHOTCOUNT, 1, P)

function solution = analyticsolve(n, hits, p)
%% DOES NOT WORK
% you have to make sure n is always bigger than HITS
% n: current shot
    buffer = zeros([n, 1]);
%     q = 1- p;
%     for i = 1 : n
%         if i < 0
%             disp('ejnye');
%         elseif i < hits
%             buffer(i) = 0;
%         elseif i == hits
%             buffer(i) = p^hits + q^hits;
%         elseif i == hits + 1
%             buffer(i) = 2 * (q*p^hits + p*q^hits);
%         elseif i == hits + 2
%             buffer(i) = 3 * (q^2*p^hits + p^2*q^hits);
%         else
%             buffer(i) = (1 - buffer(i - (hits + 2)))* (p^hits * q ^ 2 + q^hits + p ^ 2)...
%                 + buffer(i - 1);
%         end
%     end
    solution = buffer(n);
end