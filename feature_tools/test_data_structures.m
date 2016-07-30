% defining Blocks
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
assert(isequal(b({'frequency', 2}), [2     5]));
%%
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), TimeAxis('times', [1 2 3])});

b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});

assert(isequal(b({'frequency', 2}), [2     5]));
%% specifying ranges

b = Block('tensor', [1 2 3; 4 5 6; 7 8 9; 10 11 12], 'axes', {TimeAxis('times', [0 0.1 0.2 0.3]), FrequencyAxis('frequencies', [1 2 3])});
assert(isequal(b({'time', 'range', [0.1 0.2]},:),  [4  5 6; 7 8  9]));
assert(isequal(b({'time', 'range', [0.1 0.12]},:),  [4  5 6]));

b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
assert(isequal(b('time', {'frequency', 'range', [1 2]},:), [1     2; 4     5]));

%%
t = zeros(2, 3, 4);
t(:) = 1:length(t(:));
b = Block('tensor', t, 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3]), TrialAxis('times', [4 5 6 7])});

%% selecting part of the Block to create a new Block
b = Block('tensor', [1 2 3; 4 5 6], 'axes', {TimeAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
b({'time', 1}, :);
b({'frequency', 1}, :);
b({'time', 1:2}, {'frequency', 1});
newObj = b.select('frequency', 1, 'time', 1:2);
assert(newObj.isValid);

newObj2 = b.select('time', 2);
assert(newObj2.isValid);

newObj2 = b.select('time', {'range' [0 0]});
assert(newObj2.isValid);
assert(isequal(newObj2.tensor, [1 2 3]));

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
tensor = (1:100)';
indices = 5:10:100;
numberOfIndicesBefore = 2;
numberOfIndicesAfter = 3;
epochedTensor = EpochedFeature.epochTensor(tensor, indices, numberOfIndicesBefore, numberOfIndicesAfter);
assert(isequal(epochedTensor(1,:),  [3 4 5 6 7 8]));

%% Axis slicing
t = TimeAxis('times', [0:0.1:10]);
%assert(length(t(1:5).times) == 5);
t2 = t(1:5);
assert(length(t2.times) == 5);

% make sure multidimensional per-item axis properties slice only on the first dimension 
c = ChannelAxis('length', 3, 'positions', rand(3, 5));
c2 = c(1:2);
assert(isequal(size(c2.positions), [2     5]));
%assert(isequal(size(c(1:2).positions), [2     5]));

%% Feature Axis
f = FeatureAxis('length', 5);
assert(f.isValid);
f = FeatureAxis('names', {'mean', 'std'});
assert(f.isValid);
f2 = f(1);
assert(f2.isValid);

%% TrialGroup
load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_events_epochedTemporalFEature.mat']); % loads epochs in obj vartiable
b1 = obj.select('trial', {'match', 'Participant/Effect/Cognitive/Feedback/Incorrect'});
b2 = obj.select('trial', {'match', 'Participant/Effect/Cognitive/Feedback/Correct'});
t = TrialGroupAxis('groups', {b1.trial b2.trial}, 'commonHedStrings', {'Participant/Effect/Cognitive/Feedback/Incorrect' 'Participant/Effect/Cognitive/Feedback/Correct'});
assert(t.isValid);
%t = TrialGroup('groups', {b1.trial b2.trial}, 'commonHedStrings', {'Participant/Effect/Cognitive/Feedback/Incorrect' 'Participant/Effect/Cognitive/Feedback/Correct'}, 'cells', {'a'});

%% concatenate Inastance axis
iax1 = InstanceAxis('cells', [{'a'} {'b'}]);
iax2 = InstanceAxis('cells', [{'c'} {'d' 'e'}]);
conc = [iax1 iax2];
assert(conc.isValid);

tax1 = TrialAxis('times', [0 0.1]);
tax2 = TrialAxis('times', [10 20.1 30 -1], 'codes', {'1' '2' '3' '4'});
conc = [tax1 tax2];
assert(conc.isValid);
%% axis intersection
ax1 = FrequencyAxis('frequencies', [1 2 3]);
ax2 = FrequencyAxis('frequencies', [1 2]);
[inter id1 id2]= ax1.intersect(ax2);
assert(length(inter.frequencies) == 2);
assert(isequal(inter.frequencies, [1 2]'));
assert(inter.isValid);

ax1 = ChannelAxis('labels', {'a', 'b', 'c', 'd'}, 'positions', rand(5, 3));
ax2 = ChannelAxis('labels', {'d', 'b'}, 'positions', rand(2, 3));
inter = ax1.intersect(ax2);
assert(isequal(inter.labels, {'b' 'd'}'));
assert(inter.isValid);
%% concatenation

% basic without overlap
b1 = Block('tensor', [1 2 3; 4 5 6], 'axes', {TrialAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
b2 = Block('tensor', [10 20 30; 40 50 60], 'axes', {TrialAxis('times', [10 20.1]), FrequencyAxis('frequencies', [1 2 3])});
conc = [b1 b2];
assert(conc.isValid);

% with overlap detection
b1 = Block('tensor', [1 2 3; 4 5 6], 'axes', {TrialAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
b2 = Block('tensor', [10 20 30 40; 50 60 70 80], 'axes', {TrialAxis('times', [10 20.1]), FrequencyAxis('frequencies', [1 2 3 4])});
conc = [b1 b2];
assert(conc.isValid);

b1 = Block('tensor', [1 2 3; 4 5 6], 'axes', {TrialAxis('times', [0 0.1]), FrequencyAxis('frequencies', [1 2 3])});
b2 = Block('tensor', [10 20; 30 40 ], 'axes', {TrialAxis('times', [10 20.1]), FrequencyAxis('frequencies', [2 3])});
conc = [b1 b2];
assert(conc.isValid);

% write more test cases for concatention, especally for channels