% defining Blocks
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
assert(isequal(b({'frequency', 2}), [2     5]));
%%
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), TimeAxis('times', [1 2 3])});

%%
t = zeros(2, 3, 4);
t(:) = 1:length(t(:));
b = Block('tensor', t, 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3]), TrialAxis('times', [4 5 6 7])});

%% slicing axis
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
b({'time', 1}, :);
b({'frequency', 1}, :);
b({'time', 1:2}, {'frequency', 1});
newObj = b.sliceAxes('frequency', 1, 'time', 1:2);
assert(newObj.isValid);

newObj2 = b.sliceAxes('time', 2);
assert(newObj2.isValid);
%%
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), SpaceAxis('length', 3)});
assert(isequal(b({'time', '2:2'}, :), [ 4 5 6]));
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

%%

[afterRemoval, trialTimes, trialHEDStrings, trialEventTypes] = EpochedFeature.getTrialTimesFromEEGstructure('EEG', EEG, 'maxSameTypeCount', 500);
[trialFrames, trialTimes, trialHEDStrings, trialEventTypes] = EpochedFeature.getTrialTimesFromEEGstructure('EEG', EEG, 'maxSameTypeProximity', Inf);

figure; 
hold on;
scatter(trialFrames, repmat(1, [1, length(trialFrames)]), 'b', 'filled'); 
scatter(afterRemoval, repmat(1, [1, length(afterRemoval)]), 'r', 'filled');

%%
% load a sample RSVP dataset with 3 channels
load([fileparts(which('test_level1.m')) filesep 'for_feature' filesep 'RSVP_small.mat']);
obj = EpochedTemporalFeature;
obj = obj.epochChannels(EEG, 'select', {'maxSameTypeCount', 500});
%% 
load([fileparts(which('test_level1.m')) filesep 'for_feature' filesep 'RSVP_events_epochedTemporalFEature.mat']); % loads obj variable
[newObj, cleanIds, averageOutlierRatio]= obj.removeNoisyEpochs('zthreshold', 5.5);

[v id] = sort(averageOutlierRatio);
figure; imagesc(obj.index({'trial', id}, 'time', 3));
q = quantile(abs(vec(obj.index('trial', {'channel', 3}, :))), 0.98);
caxis([-q q])
%% Axis slicing
t = TimeAxis('times', [0:0.1:10]);
assert(length(t(1:5).times) == 5);

% make sure multidimensional per-item axis properties slice only on the first dimension 
c = ChannelAxis('length', 3, 'positions', rand(3, 5));
assert(isequal(size(c(1:2).positions), [2     5]));