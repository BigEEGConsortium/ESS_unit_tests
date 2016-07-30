%%
% load a sample RSVP EEG dataset with 3 channels
load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_small.mat']);
obj = EpochedTemporalFeature;
obj = obj.epochChannels(EEG, 'select', {'maxSameTypeCount', 500});

%% load lample epochs and remove noisy ones
load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_events_epochedTemporalFEature.mat']); % loads obj variable
[newObj, cleanIds, averageOutlierRatio]= obj.removeNoisyEpochs('zthreshold', 5.5);

[v id] = sort(averageOutlierRatio);
figure; imagesc(obj.index({'trial', id}, 'time', 3));
q = quantile(abs(vec(obj.index('trial', {'channel', 3}, :))), 0.98);
caxis([-q q])

%% load sample EEG and extract epochs different ways
load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_small.mat']);
[afterRemoval, trialTimes, trialHEDStrings, trialEventTypes] = EpochedFeature.getTrialTimesFromEEGstructure('EEG', EEG, 'maxSameTypeCount', 500);
[trialFrames, trialTimes, trialHEDStrings, trialEventTypes] = EpochedFeature.getTrialTimesFromEEGstructure('EEG', EEG, 'maxSameTypeProximity', Inf);

figure; 
hold on;
scatter(trialFrames, repmat(1, [1, length(trialFrames)]), 'b', 'filled'); 
scatter(afterRemoval, repmat(1, [1, length(afterRemoval)]), 'r', 'filled');

%% get ERPs

load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_events_epochedTemporalFEature.mat']); % loads epochs in obj vartiable
erp = TrialAverage(obj.select('trial', {'match', 'Participant/Effect/Cognitive/Feedback/Incorrect'}));

%% Extract ERSPs from sample RSVP EEG dataset with 3 channels
load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_small.mat']);
obj = EpochedTimeFrequencyFeature;
obj = obj.epochChannels(EEG, 'select', {'eventTypes', {'2'}}, 'normalizeByVariance', true, 'robustBaseline', true);

ersp = TrialAverage(obj);

%%
load([fileparts(which('test_level1.m')) filesep 'feature_tools' filesep 'RSVP_events_epochedTemporalFEature.mat']); % loads obj variable
addpath(genpath('/home/nima/Documents/otherscode/matlab/HEDTools/tagging/matlab'));
trial = obj.trial;

visualEffects =  trial.getHEDMatch('Event/Category/Experimental stimulus, Attribute/Onset, Participant/Effect/Visual');
buttonPress =  trial.getHEDMatch('Action/Type/Button press') | trial.getHEDMatch('Action/Button press');
incorrectFeedback = trial.getHEDMatch('Participant/Effect/Cognitive/Feedback/Incorrect');
correctFeedback = trial.getHEDMatch('Participant/Effect/Cognitive/Feedback/Correct');

dissimilarities(1).label = 'Correct Feedback';
dissimilarities(1).hedString = 'Participant/Effect/Cognitive/Feedback/Correct';
t = repmat(correctFeedback, [size(correctFeedback,2) 1]);
dissimilarities(1).matrix =  t~=t'; 

dissimilarities(2).label = 'Visual Stimulus';
t = repmat(visualEffects, [size(visualEffects,2) 1]);
dissimilarities(2).matrix =  t~=t'; 

dissimilarities(3).label = 'Incorrect Feedback';
t = repmat(incorrectFeedback, [size(incorrectFeedback,2) 1]);
dissimilarities(3).matrix =  t~=t'; 

dissimilarities(4).label = 'Button Press';
t = repmat(buttonPress, [size(buttonPress,2) 1]);
dissimilarities(4).matrix =  t~=t'; 

trialDissimilarity = squareform(pdist(obj('trial',:), 'correlation'));
[significance, correlation]  = rsa_bootstrap_significance(trialDissimilarity, dissimilarities(1).matrix);