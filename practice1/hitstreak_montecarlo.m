[seqs, pSeqs] = testprobabilityofsequence(50,0.5,5e4)

function [seqs, pSeqs] = testprobabilityofsequence(nFlip, pHead, nSim)
    % THIS CAN TAKE SOME TIME 
    % to decrease runtime:
    % - change the step in 'seqs' to something bigger
    % - reduce 'nSim'
    % - reduce 'nFlip'
    seqs = 1:ceil(nFlip/50):nFlip;
    pSeqs = arrayfun(...
        @(x)getprobabilityofsequence(nFlip, x, pHead, nSim),seqs);
    plot(seqs, pSeqs);
    xlabel("length of hit/miss streak")
    ylabel("chance of streak")
end

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
    gameResults = rand([numOfGames, numOfShots]) < chanceToHit;
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
        % hitstreak is exactly numOfReqConsecutiveHits long -> return true
        if hitStreak == numOfReqConsecutiveHits && in == 0
            ret = 1;
            hitStreak = 0;
        % missstreak is exactly numOfReqConsecutiveHits long -> return true
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