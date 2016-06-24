b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), TimeAxis('times', [1 2 3])});
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), SpaceAxis('length', 3)});
%%
s = SpaceAxis('length', 10);
assert(length(s.labels) == 10);
%%
tensor = zeros(200, 30, 40, 50);
indices = 5:10:100;
numberOfIndicesBefore = 2;
numberOfIndicesAfter = 3;
epochedTensor = EpochedFeature.epochTensor(tensor, indices, numberOfIndicesBefore, numberOfIndicesAfter);
assert(isequal(size(epochedTensor),  [10 6 30 40 50]));
%%
tensor = [1:100]';
indices = 5:10:100;
numberOfIndicesBefore = 2;
numberOfIndicesAfter = 3;
epochedTensor = EpochedFeature.epochTensor(tensor, indices, numberOfIndicesBefore, numberOfIndicesAfter);
assert(isequal(epochedTensor(1,:),  [3 4 5 6 7 8]));