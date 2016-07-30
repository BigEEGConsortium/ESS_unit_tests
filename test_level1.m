%% Level 1 validation
obj = level1Study([fileparts(which('test_level1.m')) filesep 'dummy_level_1']);
obj.validate;
%% Level 1 writing and reading
obj = level1Study([fileparts(which('test_level1.m')) filesep 'dummy_level_1']);
obj.write(tempname);
%% Level 1 creating a new level 1 container
obj = level1Study([fileparts(which('test_level1.m')) filesep 'dummy_level_1']);
tmpDir = tempname
obj.createEssContainerFolder(tmpDir);

obj2 = level1Study(tmpDir);
obj2.validate;