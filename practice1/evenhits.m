testProbabilityOfEvenHit(21,5000)

function testProbabilityOfEvenHit(nShot, nSim)
    pHit = 0:0.01:1; 
    pEvenanalytical = arrayfun(@(x) getprobabilityofevenhit_analytical(nShot, x), pHit);
    pEvenMonteCarlo = arrayfun(@(x) getprobabilityofevenhit_montecarlo(nShot, x, nSim), pHit);
    plot(pHit, pEvenanalytical, pHit, pEvenMonteCarlo);
    legend('Analytic solution', 'Monte Carlo method')
    xlabel('chance to hit')
    ylabel('chance to get even shots')
end


function pEven = getprobabilityofevenhit_analytical (nShot, pHit)
    % sum up Ps of each even hitcount
    possibleHits = 0:2:nShot;
    pEven = sum(...
        arrayfun(@(x) getprobabilityofhits_analytical(nShot,pHit,x), possibleHits));
end

function p = getprobabilityofhits_analytical(nShot, pHit, nHit)
    % binomial dist
    p = nchoosek(nShot,nHit) * pHit.^nHit * (1-pHit).^(nShot - nHit);
end
    
function pEven = getprobabilityofevenhit_montecarlo (nShot, pHit, nSim)
    % columns contain individual games, rows contain the shots
    % 1 is a hit 0 is a miss
    bHits = rand([nSim, nShot]) < pHit;
    bEvenGames = zeros([1,nSim]);
    for i = 1:nSim
        bEvenGames(i) = ~mod(sum(bHits(i,:)), 2);
    end
    pEven = sum(bEvenGames) / nSim;
end
