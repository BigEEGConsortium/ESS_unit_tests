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

%%
[afterRemoval, trialTimes, trialHEDStrings, trialEventTypes] = EpochedFeature.getTrialTimesFromEEGstructure('EEG', EEG, 'maxSameTypeCount', 500);
[trialFrames, trialTimes, trialHEDStrings, trialEventTypes] = EpochedFeature.getTrialTimesFromEEGstructure('EEG', EEG, 'maxSameTypeProximity', Inf);

figure; 
hold on;
scatter(trialFrames, repmat(1, [1, length(trialFrames)]), 'b', 'filled'); 
scatter(afterRemoval, repmat(1, [1, length(afterRemoval)]), 'r', 'filled');