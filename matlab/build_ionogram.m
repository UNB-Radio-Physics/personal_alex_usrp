function [freq,hght,amp,dopp,dopp_broad] = build_ionogram(baseDir,dt,ch_no,code_type,total_num,lMODIS,lpulse_shaping)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lMODIS = true; % IF MODIS
% lMODIS = false; % IF USRP 

% Shift of the pulse sent, in pts
shift = 25;

% Data sampling rate, samples per second.
samp_rate = 2e5;

% Single pulse length, pts.
pulse_length = 1100;

% Generate complimentary code to correlate with
[pls_odd, pls_even, ~] = generate_complementary_code(code_type,false,false,lMODIS,lpulse_shaping);
%[pls_odd, pls_even, ~] = generate_complementary_code(code_type,false,true,lMODIS,lpulse_shaping);

% Normalize values to be in [-1..1] range
if isreal(pls_odd)
    pls_odd = complex(double(pls_odd/max(pls_odd)),0);
    pls_even = complex(double(pls_even/max(pls_even)),0);
else
    pls_odd = pls_odd/max(abs(pls_odd));
    pls_even = pls_even/max(abs(pls_even));
end

files = dir(sprintf('%s/%s*_c%d.dat',baseDir,datestr(dt,'yyyymmdd_hhMMss'),ch_no));

freq=zeros(1,size(files,1),'uint32');
fft_amp=zeros(pulse_length,size(files,1),'single');
dopp=fft_amp;
dopp_broad=dopp;

for i=1:size(files,1)
    filename = files(i).name;
    f_ind = strfind(filename,'f');
    freq(i) = sscanf(filename(f_ind+1:f_ind+8),'%d');

    [fft_amp(:,i),dopp(:,i),dopp_broad(:,i)]=...
        get_scan_line(sprintf('%s/%s',baseDir,filename),pls_odd,pls_even,freq(i),samp_rate,pulse_length,total_num);
end

sol=299792.458; % Speed of light, km/s
hght=single(sol*((1:size(fft_amp,1))-shift)/(2*samp_rate));

h_from = sol*length(pls_odd)/(2*samp_rate);
%h_from = -10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind_from=find(hght>=h_from,1);
ind_from = 101;
%ind_to=find(hght>(max(hght)-shift),1);
ind_to=length(hght);
ind_to=1005;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Build output parameters
hght=hght(ind_from:ind_to);
amp=fft_amp(ind_from:ind_to,:);
dopp=dopp(ind_from:ind_to,:);
dopp_broad=dopp_broad(ind_from:ind_to,:);

function [max_fft,max_fr,fr_wdth] = get_scan_line(filename,pls_odd,pls_even,freq,samp_rate,pulse_length,total_num)

% Read data from file
fin = fopen(filename);
data = fread(fin,'int16');
fprintf('Freq: %d, Max amp: %d, Min amp: %d\n',freq,max(data),min(data));
data = data/(2^15); % Normalize values to be in [0..1] range
fclose(fin);

complex_data = complex(data(1:2:size(data,1)),data(2:2:size(data,1)));

ind = 0;
for i=0:2:total_num-1
    corr = ...
        xcorr(complex_data(i*pulse_length+1:i*pulse_length+pulse_length), pls_odd) + ...
        xcorr(complex_data((i+1)*pulse_length+1:(i+1)*pulse_length+pulse_length), pls_even);

    corr_data(ind*pulse_length+1:ind*pulse_length+pulse_length) = ...
        corr(pulse_length:2*pulse_length-1);

    ind = ind + 1;
end

bin_compr_data=reshape(corr_data,[pulse_length, total_num/2]);
bin_compr_ft=fftshift((fft(bin_compr_data,[],2)),2);

% Calculate index of zero frequency in fftshift
center_ind=size(bin_compr_ft,2)/2+1;

% Calculate index of maximum amplitude in fftshift
[max_fft_amp,max_fr_ind]=max(bin_compr_ft,[],2);

max_fft=single(max_fft_amp);

% Calculate frequency resolution (step)
fr_res=1/(length(corr_data)/samp_rate*2);

% Calculate Doppler shift
max_fr=single(max_fr_ind-center_ind)*fr_res; 

% Calculate spectrum broadening 
fr_wdth=zeros(1,pulse_length,'single');
bin_compr_ft_log=20*log10(abs(bin_compr_ft));
avg_fft_amp=mean(bin_compr_ft_log,2);

for i=1:size(bin_compr_ft,1)
    mx_tr=avg_fft_amp(i)+3; % Noise level +3dB threshold
    rm=find(bin_compr_ft_log(i,max_fr_ind(i)+1:end)<mx_tr,1);
    lm=find(bin_compr_ft_log(i,1:max_fr_ind(i)-1)<mx_tr,1,'last');
    if isempty(rm) || isempty(lm)
        fr_wdth(i)=fr_res;
    else
        fr_wdth(i)=(rm+max_fr_ind(i)-lm-1)*fr_res;
    end
end