clear;

NIon2 = 434;

raw_file_path = 'E:\bliss_raw_4ch_1234\2024-03-06_\ch01\';
% raw_corrupt_file_path = 'c:/usrp/sounder/corrupt/';

raw_file_mask = [raw_file_path '202403*.dat'];

files=dir(raw_file_mask);

Nall = size(files,1);

name_dt = char(zeros(Nall,15));

name_dt0 = files(1).name(1:15);

IndFiles = 1;
IndSounds = 1;


for j=1:Nall
    name_dt(j,:) = files(j).name(1:15);
    if(strcmp(name_dt0,name_dt(j,:)))
        IndFiles = IndFiles+1;
    else
        name_dt0 = files(j).name(1:15);
        NumDat(IndSounds,1) = IndFiles-1;
        NameSounding(IndSounds,:) = name_dt(j-1,:);
        IndFiles = 2;
        IndSounds = IndSounds+1;
    end
end

NumDat(IndSounds,1) = IndFiles-1;


% Nsoundings = size(files_all,1)/NIon2;