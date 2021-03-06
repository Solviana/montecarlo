P = 0.5; % chance to hit
SHOTCOUNT = 100; % 100 shots in a game as stated in problem description
TESTCOUNT = 1e6; % how many games to simulate before evaulation
HITS = 5; % how many hits are expected (= 5 in problem description)

getprobabilityofsequence(SHOTCOUNT,HITS,P,TESTCOUNT)

function pSeq = getprobabilityofsequence(nFlip, lSeq, pHead, nSim)
    % generate the games
    games = playgames(nSim, nFlip, pHead);
    results = zeros([nSim,1]);
    % multithreaded loop, requires parallel computing toolbox!
    parfor i = 1 : nSim
        results(i) = evaluategame(games(i,:), lSeq);
    end
    % results is a boolean array -> sum returns the number of games that passed
    % the criteria
    pSeq = sum(results) / nSim;
end

function gameResults = playgames(numOfGames, numOfShots, chanceToHit)
% gameResults: n*m logical array. true represents a hit
% false a miss. m is the number of shots within a game n is the number of
% games
    gameResults = rand([numOfGames, numOfShots]) > chanceToHit;
end

function result = evaluategame(gameResult, numOfReqConsecutiveHits)
% checks a single game
% numOfReqConsecutiveHits: how many consecutive hits/misses required to pass 
% If the criteria is fulfilled at least once (multiple times allowed as well) 
% then game is passed
    result = any( ...
        arrayfun(getevaluator(numOfReqConsecutiveHits), gameResult));
end

function evalFun = getevaluator(numOfReqConsecutiveHits)
% closure for checking consecutive hits/misses; 
    hitStreak = 0;
    missStreak = 0;
    function ret = aggregator(in)
        ret = 0;
        if hitStreak == numOfReqConsecutiveHits && in == 0
            ret = 1;
            hitStreak = 0;
        elseif missStreak == numOfReqConsecutiveHits && in == 1
            ret = 1;
            missStreak = 0;
        elseif in
            hitStreak = hitStreak + 1;
            missStreak = 0;
        else
            missStreak = missStreak + 1;
            hitStreak = 0;
        end
    end
    evalFun = @aggregator;
end