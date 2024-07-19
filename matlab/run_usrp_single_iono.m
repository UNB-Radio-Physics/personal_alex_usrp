%
% Runs USRP ionogram scannings once
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

% DELECT MODIS OR USRP
lMODIS = true; % IF MODIS
% lMODIS = false; % IF USRP 
if lMODIS
    code_type='32b'; % MODIS
    NIon2 = 300;
else
    code_type='16b'; % USRP
    NIon2 = 434;
end
% code_type='16b'; % USRP
fft_length=32;
usrp_no=2;

exe_folder='c:/usrp/sounder/';
ini_file1='usrp_sounder1.ini';
ini_file2='usrp_sounder2.ini';
data_folder='c:/usrp/data/raw/';
img_folder='c:/usrp/data/img/';
mat_folder='c:/usrp/data/mat/';
code_folder='c:/usrp/sounder/code/';
mode_file='iono.ini';
current_folder=pwd;

tic
% Update code files
copyfile([code_folder,code_type,'/tx_buff_even.dat'],[exe_folder,'tx_buff_even.dat']);
copyfile([code_folder,code_type,'/tx_buff_odd.dat'],[exe_folder,'tx_buff_odd.dat']);
fprintf('%s Code files updated with: %s\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),code_type);

% Run USRP sounder
fprintf('%s Starting sounding...\n',datestr(now,'hh:MM:ss'));
dt=now;
cd(exe_folder);
if usrp_no>1
%    system(sprintf('./usrp_sounder %s %s &',ini_file2,mode_file));
%    system(sprintf('./usrp_sounder %s %s',ini_file1,mode_file));
else
%    system(sprintf('./usrp_sounder %s %s',ini_file1,mode_file));
end
cd(current_folder);
fprintf('%s Sounding finished. Elapsed time: %.2f sec.\n',datestr(now,'hh:MM:ss'),toc);

% -----------------------
% Process USRP data
% -----------------------

tic
fprintf('%s Processing ionogram...\n',datestr(now,'hh:MM:ss'));

% Get ionogram exact date time
% raw_file_mask=sprintf('%s%s_*.dat',exe_folder,datestr(dt,'yyyymmdd'));
raw_file_mask = 'c:/usrp/sounder/20240601_000001*.dat';
files=dir(raw_file_mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ADD ALL SOUNDINGS
% files_all=dir(raw_file_mask);
% Nsoundings = size(files_all,1)/NIon2;
% distr_p = zeros(Nsoundings,4);
% for pp=1:Nsoundings
% files = files_all((1+NIon2*(pp-1)):(NIon2*pp));    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_name=files(end).name;
dt=datenum(datetime(file_name(1:15),'InputFormat','yyyyMMdd_HHmmss'));
utc_dt=datenum(datetime(dt,'ConvertFrom','datenum','TimeZone','local'));

% Find number of channels
ch_file_mask=sprintf('%s%s*.dat',exe_folder,file_name(1:end-6));
ch_files=dir(ch_file_mask);
ch_no=length(ch_files);
fprintf('%s Number of channels: %d.\n',datestr(now,'hh:MM:ss'),ch_no);

date_folder=datestr(dt,'yyyy-mm-dd');

for i=0:ch_no-1
    fprintf('%s Processing ionogram for channel %d.\n',datestr(now,'hh:MM:ss'),i);

    close all

    % Build ionogram
    [freq,hght,ampl(:,:,i+1),dopp(:,:,i+1)]=build_ionogram(exe_folder,utc_dt,i,code_type,fft_length,lMODIS);

    % Plot ionogram image
    [fig]=plot_ionogram(freq,hght,ampl(:,:,i+1),code_type,utc_dt);

    % Save image file
    img_file_name=sprintf('%s/%s_c%d.png',current_folder,datestr(utc_dt,'yyyymmdd_hhMMss'),i);
    print(fig,img_file_name,'-dpng','-r0');

    % Save mat file
    mat_file_name=sprintf('%s/%s_c%d.mat',current_folder,datestr(utc_dt,'yyyymmdd_hhMMSS'),i);
    amp=ampl(:,:,i+1);
    code=code_type;
    utc=utc_dt;
    save(mat_file_name,'utc','code','freq','hght','amp','dopp');

    % Move img file
    fld=sprintf('%s%s',img_folder,date_folder);
    if ~exist(fld, 'dir')
        mkdir(fld);
    end
    movefile(img_file_name,fld);

    % Move mat file
    fld=sprintf('%s%s',mat_folder,date_folder);
    if ~exist(fld, 'dir')
        mkdir(fld);
    end
    movefile(mat_file_name,fld);
end

% Plot polarization ionogram
if ch_no>1
    [f1,f2,distr_p12]=plot_polarization_ionogram(utc_dt,freq,hght,ampl(:,:,1:2));
    distr_dt = utc_dt;

    % Save image files
    img_file_name1=sprintf('%s/%s_p01.png',current_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
    print(f1,img_file_name1,'-dpng','-r0');
    img_file_name2=sprintf('%s/%s_d01.png',current_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
    print(f2,img_file_name2,'-dpng','-r0');

    % Move image files
    fld=sprintf('%s%s',img_folder,date_folder);
    movefile(img_file_name1,fld);
    movefile(img_file_name2,fld);
end

if ch_no>3
    [f1,f2,distr_p34]=plot_polarization_ionogram(utc_dt,freq,hght,ampl(:,:,3:4));

    % Save image files
    img_file_name1=sprintf('%s/%s_p23.png',current_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
    print(f1,img_file_name1,'-dpng','-r0');
    img_file_name2=sprintf('%s/%s_d23.png',current_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
    print(f2,img_file_name2,'-dpng','-r0');

    % Move image files
    fld=sprintf('%s%s',img_folder,date_folder);
    movefile(img_file_name1,fld);
    movefile(img_file_name2,fld);
end

% save and move polarization mat file
if ch_no>1   
    % Save polarization mat file
    mat_p_file_name=sprintf('%s/%s_p.mat',current_folder,datestr(utc_dt,'yyyymmdd_hhMMSS'));
    utc=utc_dt;
    
    if ch_no>3
        save(mat_p_file_name,'utc','distr_p12','dist_p34');
    else
        save(mat_p_file_name,'utc','distr_p12');
    end

    % Move mat file
    fld=sprintf('%s%s',mat_folder,date_folder);
    if ~exist(fld, 'dir')
        mkdir(fld);
    end
    movefile(mat_p_file_name,fld);
end

% Move raw files
fld=sprintf('%s%s',data_folder,date_folder);
if ~exist(fld, 'dir')
    mkdir(fld);
end
raw_sounding_file_mask = [files(1).folder '\' files(1).name(1:15) '*.dat'];
movefile(raw_sounding_file_mask,fld);
% movefile(raw_file_mask,fld);

fprintf('%s Ionograms processed. Elapsed time: %.2f sec.\n',datestr(now,'hh:MM:ss'),toc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ADD ALL SOUNDINGS
% fprintf('Sounding %03d from %03d was processed\n\n',pp,Nsoundings);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
