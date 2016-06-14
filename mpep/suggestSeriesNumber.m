function num = suggestSeriesNumber(animal)
%SUGGESTSERIESNUMBER Given an animal suggest a series number for it.
% Will suggest the highest series number that exists if there are any,
% otherwise it suggets 1.
dirs = Paths();
dataDir = dirs.data;
num = maxNumberInDir(fullfile(dataDir, animal));
if num == 0
    num = 1;
end
end

