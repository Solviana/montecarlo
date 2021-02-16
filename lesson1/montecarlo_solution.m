P = 0.5; % chance to hit
SHOTCOUNT = 100; % 100 shots in a game as stated in problem description
TESTCOUNT = 1e6; % how many games to simulate before evaulation
HITS = 5; % how many hits are expected (= 5 in problem description)

% generate the games
games = playgames(TESTCOUNT, SHOTCOUNT, P);
results = zeros([TESTCOUNT,1]);
% multithreaded loop, requires parallel computing toolbox!
parfor i = 1 : TESTCOUNT
    results(i) = evaluategame(games(i,:), HITS);
end
% results is a boolean array -> sum returns the number of games that passed
% the criteria
solution = sum(results) / TESTCOUNT;

function gameResults = playgames(numOfGames, numOfShots, chanceToHit)
% gameResults: n*m logical array. true represents a hit
% false a miss. m is the number of shots within a game n is the number of
% games
    gameResults = rand([numOfGames, numOfShots]) > chanceToHit;
end

function result = evaluategame(gameResult, numOfReqConsecutiveHits)
% checks a single game
% numOfReqConsecutiveHits: how many consecutive hits required to pass the criteria.
% If the criteria is fulfilled at least once (multiple times allowed as well) 
% then game is passed
    result = any( ...
        arrayfun(getevaluator(numOfReqConsecutiveHits), gameResult));
end

function evalFun = getevaluator(numOfReqConsecutiveHits)
% closure for checking consecutive hits. The returned function returns true
% if there were numOfReqConsecutiveHits hits in a row.
    hitStreak = 0;
    function ret = aggregator(in)
        ret = 0;
        if hitStreak == numOfReqConsecutiveHits
            ret = 1;
        elseif in
            hitStreak = hitStreak + 1;
        else
            hitStreak = 0;
        end
    end
    evalFun = @aggregator;
end
