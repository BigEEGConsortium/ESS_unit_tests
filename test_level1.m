%% Level 2 validation
obj = level1Study([fileparts(which('test_level1.m')) filesep 'dummy_level_1']);
obj.validate;