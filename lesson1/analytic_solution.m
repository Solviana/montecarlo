%% CONSTANTS
P = 0.5; % chance to hit
SHOTCOUNT = 100; % 100 shots in a game as stated in problem description
HITS = 5; % how many hits are expected (= m in solution description)

%% Solution:
% Let $P_{n,m}$ be the chance to get at least m consecutive hits at least
% once from n shots.
% In this case $P_{n,m}-P_{n-1,m}$ means there are NO long enough streaks in the
% first i-1 shots but the ith shot ends a streak that is long enough. This means the
% last m+1 shots are 1 miss followed by m hits (chance $p^m*(1-p)$). 
% Which is the same as:
% $P_{n,m}-P_{n-1,m} = (1 - P_{n-(m+1), m}) * p^m*(1-p)$
% The script calculates this recursion with n == HITS and i = n

%% Script for the recursion
analyticSolution = analyticsolve(SHOTCOUNT, HITS, P);

function solution = analyticsolve(n, hits, p)
% you have to make sure n is always bigger than HITS
% n: current shot
    buffer = zeros([n, 1]);
    for i = 1 : n
        if i < 0
            disp('ejnye');
        elseif i < hits
            buffer(i) = 0;
        elseif i == hits
            buffer(i) = p^hits;
        else
            buffer(i) = (1 - buffer(i - hits))* p^hits * (1 - p)...
                + buffer(i - 1);
        end
    end
    solution = buffer(n);
end