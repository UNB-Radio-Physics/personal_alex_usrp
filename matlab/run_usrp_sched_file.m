%
% Runs USRP ionogram scannings based on the provided schedule file (yyyy-mm.sch)
%

code_type=['16b'];
code_type_ind=1;
fft_length=[32];
usrp_no=2;

exe_folder='/home/usrp/sounder/';
data_folder='/home/usrp/data/raw/';
img_folder='/home/usrp/data/img/';
mat_folder='/home/usrp/data/mat/';
code_folder='/home/usrp/sounder/code/';
global ini_file1
global ini_file2
ini_file1='usrp_sounder1.ini';
ini_file2='usrp_sounder2.ini';
curr_folder=pwd;

ct=now;
sched=read_sched(exe_folder,ct);
next_sched=sched(find([sched.dt]>ct,1));
freq_file_hours=read_freq_files(exe_folder);
update_freq_file(exe_folder,freq_file_hours,next_sched.dt);
update_code_files(code_folder,exe_folder,code_type(1,:));

fprintf('%s Waiting for the next time: %s...\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),datestr(next_sched.dt,'yyyy-mm-dd hh:MM:ss'));

while 1
    ct=now;
    if ct>next_sched.dt
        pause(0.5);
        perform_scan(ct,curr_folder,exe_folder,data_folder,img_folder,mat_folder,code_type(code_type_ind,:),fft_length,next_sched.mode,usrp_no);

        if code_type_ind<size(code_type,1)
            code_type_ind=code_type_ind+1;
            update_code_files(code_folder,exe_folder,code_type(code_type_ind,:));
            next_sched.dt=addtodate(next_sched.dt,80,'second');
        else
            code_type_ind=1;
            update_code_files(code_folder,exe_folder,code_type(code_type_ind,:));

            n_i=find([sched.dt]>next_sched.dt,1);
            if isempty(n_i)
                sched=read_sched(exe_folder,datenum(year(next_sched.dt),month(next_sched.dt)+1,1));
                n_i=find([sched.dt]>next_sched.dt,1);
            end
            next_sched=sched(n_i);
            update_freq_file(exe_folder,freq_file_hours,next_sched.dt);
        end

        fprintf('%s Waiting for the next time: %s...\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),datestr(next_sched.dt,'hh:MM:ss'));
    end

    pause(0.05);
end

function perform_scan(ct,curr_folder,exe_folder,data_folder,img_folder,mat_folder,code,fft_length,mode_file,usrp_no)
    global ini_file1
    global ini_file2

    % Run sounder program
    tic
    if isnan(mode_file)
        mode_file_name='default.ini';
    else
        mode_file_name=mode_file;
    end
    fprintf('%s Mode: %s. Performing a scan...\n',datestr(ct,'yyyy-mm-dd hh:MM:ss'),mode_file_name);
    cd(exe_folder);
    if usrp_no>1
        if ispc
            system(sprintf('start /B usrp_sounder.exe %s %s',ini_file2,mode_file));
            system(sprintf('usrp_sounder.exe %s %s',ini_file1,mode_file));
        else
            system(sprintf('./usrp_sounder %s %s &',ini_file2,mode_file));
            system(sprintf('./usrp_sounder %s %s',ini_file1,mode_file));
        end
    else
        if ispc
            system(sprintf('usrp_sounder.exe %s %s',ini_file1,mode_file));
        else
            system(sprintf('./usrp_sounder %s %s',ini_file2,mode_file));
        end
    end
    cd(curr_folder);
    fprintf('%s Scan performed. Elapsed time: %.2f sec.\n',datestr(ct,'yyyy-mm-dd hh:MM:ss'),toc);

    % Process ionogram
    tic
    fprintf('%s Processing ionogram data...\n',datestr(now,'yyyy-mm-dd hh:MM:ss'));

    % Get ionogram exact date time
    raw_file_mask=sprintf('%s%s_*.dat',exe_folder,datestr(ct,'yyyymmdd'));
    files=dir(raw_file_mask);
    if length(files) < 6
        fprintf('%s No data files found.\n',datestr(now,'yyyy-mm-dd hh:MM:ss'));
        return
    end
    file_name=files(end).name;
    dt=datenum(datetime(file_name(1:15),'InputFormat','yyyyMMdd_HHmmss'));
    utc_dt=datenum(datetime(dt,'ConvertFrom','datenum','TimeZone','local'));

    % Find number of channels
    ch_file_mask=sprintf('%s%s*.dat',exe_folder,file_name(1:end-6));
    ch_files=dir(ch_file_mask);
    ch_no=length(ch_files);
    fprintf('%s Number of channels: %d.\n',datestr(now,'hh:MM:ss'),ch_no);

    for i=1:length(fft_length)
        close all

        for k=0:ch_no-1
            fprintf('%s Processing ionogram for channel %d.\n',datestr(now,'hh:MM:ss'),k);

            % Build ionogram
            [freq,hght,ampl(:,:,k+1),dopp(:,:,k+1)]=build_ionogram(exe_folder,utc_dt,k,code,fft_length(i));

            % Plot ionogram image
            [fig]=plot_ionogram(freq,hght,ampl(:,:,k+1),code,utc_dt);

            % Save image file
            img_file_name=sprintf('%s/%s_c%d.png',curr_folder,datestr(utc_dt,'yyyymmdd_hhMMss'),k);
            print(fig,img_file_name,'-dpng','-r0');

            % Save mat file
            mat_file_name=sprintf('%s/%s_c%d.mat',curr_folder,datestr(utc_dt,'yyyymmdd_hhMMSS'),k);
            amp=ampl(:,:,k+1);
            utc=utc_dt;
            save(mat_file_name,'utc','code','freq','hght','amp','dopp');
        end
    end

    if ch_no>1
        % Plot polarization ionogram for ch0 & ch1
        [f1,f2]=plot_polarization_ionogram(utc_dt,freq,hght,ampl(:,:,1:2));

        % Save image files
        img_file_name1=sprintf('%s/%s_p01.png',curr_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
        print(f1,img_file_name1,'-dpng','-r0');
        img_file_name2=sprintf('%s/%s_d01.png',curr_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
        print(f2,img_file_name2,'-dpng','-r0');
    end

    if ch_no>3
        % Plot polarization ionogram for ch2 & ch3
        [f1,f2]=plot_polarization_ionogram(utc_dt,freq,hght,ampl(:,:,3:4));

        % Save image files
        img_file_name1=sprintf('%s/%s_p23.png',curr_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
        print(f1,img_file_name1,'-dpng','-r0');
        img_file_name2=sprintf('%s/%s_d23.png',curr_folder,datestr(utc_dt,'yyyymmdd_hhMMss'));
        print(f2,img_file_name2,'-dpng','-r0');
    end

    % Move raw files
    date_folder=datestr(dt,'yyyy-mm-dd');
    fld=sprintf('%s%s',data_folder,date_folder);
    if ~exist(fld, 'dir')
        mkdir(fld);
    end
    movefile(raw_file_mask,fld);

    % Move img files
    img_file_mask=sprintf('%s/%s_*.png',curr_folder,datestr(ct,'yyyymmdd'));
    fld=sprintf('%s%s',img_folder,date_folder);
    if ~exist(fld, 'dir')
        mkdir(fld);
    end
    movefile(img_file_mask,fld);

    % Move mat files
    mat_file_mask=sprintf('%s/%s_*.mat',curr_folder,datestr(ct,'yyyymmdd'));
    fld=sprintf('%s%s',mat_folder,date_folder);
    if ~exist(fld, 'dir')
        mkdir(fld);
    end
    movefile(mat_file_mask,fld);

    fprintf('%s Ionograms processed. Elapsed time: %.2f sec.\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),toc);
end

% Updates the code (TX buffer) files
function update_code_files(code_folder,exe_folder,code_type)
    copyfile([code_folder,code_type,'/tx_buff_even.dat'],[exe_folder,'tx_buff_even.dat']);
    copyfile([code_folder,code_type,'/tx_buff_odd.dat'],[exe_folder,'tx_buff_odd.dat']);
    fprintf('%s Code files updated with: %s\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),code_type);
end

% Updates the frequency file according to the time of the day
function update_freq_file(folder,freq_file_hours,dt)
    i=find(hour(dt)>=freq_file_hours,1,'last');
    freq_file_name=sprintf('%02d.freq',freq_file_hours(i));
    if (exist([folder,freq_file_name],'file'))
        copyfile([folder,freq_file_name],[folder,'freq.txt']);
        fprintf('%s Frequency file updated with: %s\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),freq_file_name);
    end
end

% Reads the list of existing frequency files (*.freq)
function [freq_file_hours]=read_freq_files(folder)
    freq_files=dir([folder,'*.freq']);
    freq_file_hours=[];
    for i=1:length(freq_files)
        filename=freq_files(i).name;
        freq_file_hours(i)=str2double(filename(1:2));
    end
    fprintf('%s Frequency files found: %s\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),strjoin(string(vertcat(freq_files.name)),', '));
end

% Reads the schedule file
function [sched]=read_sched(folder,dt)
    sch_file_name=sprintf('%d-%02d.sch',year(dt),month(dt));
    f=fopen([folder,sch_file_name]);
    if f<0
        fprintf('%s Schedule file not found.\n',datestr(now,'yyyy-mm-dd hh:MM:ss'));
        sched=struct('dt',datenum(now+years(1)),'mode',NaN);
        return
    end
    i=1;
    l=fgetl(f);
    while ischar(l)
        dt=datenum(l(1:19),'yyyy-mm-dd hh:MM:ss');
        if length(l)>19
            mode=strtrim(l(20:end));
        else
            mode=NaN;
        end
        sched(i)=struct('dt',dt,'mode',mode);
        l=fgetl(f);
        i=i+1;
    end
    fclose(f);
    fprintf('%s Schedule file found: %s\n',datestr(now,'yyyy-mm-dd hh:MM:ss'),sch_file_name);
end