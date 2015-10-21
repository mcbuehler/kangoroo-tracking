function tests = test
tests = functiontests(localfunctions);
end

function testCalculate_similariy_score(testCase)
actSolution = calculate_similarity_score(I1,I2,X,Y,descriptors_I1);
expSolution = [2 1];
verifyEqual(testCase,actSolution,expSolution)
end

function testImaginarySolution(testCase)
actSolution = quadraticSolver(1,2,10);
expSolution = [-1+3i -1-3i];
verifyEqual(testCase,actSolution,expSolution)
end