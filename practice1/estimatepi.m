testIterations = 1:10:100000;
testResults = zeros([1, length(testIterations)]);
parfor i = 1:length(testIterations)
    testResults(i) = testestimatepi(testIterations(i))
end
% testResults = arrayfun(@testestimatepi, testIterations);
plot(testIterations, testResults);
xlabel('num of iterations')
ylabel('value of pi')

function piVal = testestimatepi(nSample)
    nPos = rand([2, nSample]); % column1: x
    bPassed = (nPos(1,:).^2 + nPos(2,:).^2) <= 1;
    piVal = sum(bPassed)/nSample * 4;
end

