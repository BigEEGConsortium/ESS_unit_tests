%% Level 2 validation
obj = level2Study([fileparts(which('test_level2.m')) filesep 'dummy_level_2']);
obj.validate;

%% local creation test
%obj = level2Study('level1XmlFilePath', '/data/ucsd_rsvp/level_1');
%obj.createLevel2Study(tempname, 'forTest', true, 'sessionSubset', 2);