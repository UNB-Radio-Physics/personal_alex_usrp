function [f1,f2,distr_p]=plot_polarization_ionogram(dt,freq,hght,amp,lpulse_shaping,code)

distr_p = zeros(1,4)*NaN;

% SNR threshold, dB
snr_tr=10;

% Start searching for local max from (index of element in -180..180 array)
angle_start_ind=find(-180:180==-150);
angle_stop_ind=find(-180:180==150);

pwr=20*log10(abs(amp));
pwr=pwr-repmat(mode(round(pwr)),size(pwr,1),1)-2;
pwr_all=max(pwr(:,:,1),pwr(:,:,2));
pwr_all(pwr_all<snr_tr)=NaN;
ph_diff=rad2deg(wrapToPi(angle(amp(:,:,1))-angle(amp(:,:,2))));
ph_diff(isnan(pwr_all))=NaN;

% Plot phase difference distribution
f2=figure;
x_pdf=-180:1:180;
h_d=histogram(ph_diff,x_pdf,'Normalization','pdf','EdgeColor','none');
ax=gca;
hold on
hst_x=x_pdf(1:end-1)+0.5;
hst_y=h_d.Values;
angle_ind=angle_start_ind:angle_stop_ind;
tf=islocalmax(hst_y(angle_ind),'MinSeparation',100); % Find local maxima with at least 100 deg separation
plot(hst_x(angle_ind(tf)),hst_y(angle_ind(tf)),'r*');
pd_ind=1;
lmax=angle_ind(find(tf));

for i=lmax
    % Select a range of angles to use for fitting the Gaussian distribution
    ind=max(max(1,i-50),angle_start_ind):min(min(i+49,numel(hst_y)),angle_stop_ind);
    ph_from=min(hst_x(ind));
    ph_to=max(hst_x(ind));
    ph_sub=reshape(ph_diff(ph_diff<ph_to&ph_diff>ph_from),[],1);

    % If there is not enough data for fitting, skip the maximum
    if length(ph_sub)<2
        if i==length(lmax)
            break;
        else
            continue
        end
    end
    pd(pd_ind)=fitdist(ph_sub,'Normal');
    ph_range=ph_from:ph_to;
    y=pdf(pd(pd_ind),ph_range);
    pd_coef=length(ph_sub)/numel(ph_diff);
    line(hst_x(ind),pd_coef*y,'Color','r','LineWidth',2);
    text(hst_x(i),hst_y(i),sprintf('  %0.1f',hst_x(i)));
    text(pd(pd_ind).mean,pd_coef*y(find(abs(ph_range-pd(pd_ind).mean)<0.5)),sprintf('  %0.1f \x00B1 %0.1f',pd(pd_ind).mean,pd(pd_ind).sigma));
    pd_ind=pd_ind+1;

    if pd_ind==3
        break;
    end
end

% Calculate distributions parameters 
if size(pd,2)>0
    distr_p(1) = pd(1).mean;
    distr_p(3) = pd(1).sigma;
end
if size(pd,2)>1
    distr_p(2) = pd(2).mean;
    distr_p(4) = pd(2).sigma;
end


if lpulse_shaping
    title(sprintf('%s, Phase diff PDF, %s, Pulse shaping ON',datestr(dt,'YYYY-mm-DD HH:MM:SS'),code));
else
    title(sprintf('%s, Phase diff PDF, %s, Pulse shaping OFF',datestr(dt,'YYYY-mm-DD HH:MM:SS'),code));
end
xlabel('\Delta\phi [\circ]');
ylabel('Rel freq');
set(ax,'XLim',[-180,180]);
set(ax,'TickDir','both');
set(ax,'FontSize',12);
set(ax,'XMinorTick','on','YMinorTick','on');

set(ax,'FontSize',18);
set(f2,'PaperUnits','points');
set(f2,'PaperPosition',[0 0 800 600]);

% Plot phase difference
if exist('pd','var') && length(pd) > 1
    s_coef=2.0; % Sigma coefficient
    ph_diff(~((ph_diff>(pd(1).mean-s_coef*pd(1).sigma)&ph_diff<(pd(1).mean+s_coef*pd(1).sigma))|...
        (ph_diff>(pd(2).mean-s_coef*pd(2).sigma)&ph_diff<(pd(2).mean+s_coef*pd(2).sigma))))=NaN;
end
f1=figure;
h=pcolor(single(freq)/1e6,hght,ph_diff);
ax=gca;
colormap(ax, parula);
set(h, 'EdgeColor', 'none');
xlabel('Freq [MHz]');
ylabel('h'' [km]');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlim([1 10]); % Set MaxFr to 10 MHz
xticks(1:10);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if lpulse_shaping
    title(sprintf('%s, Phase diff, %s, Pulse shaping ON',datestr(dt,'YYYY-mm-DD HH:MM:SS'),code));
else
    title(sprintf('%s, Phase diff, %s, Pulse shaping OFF',datestr(dt,'YYYY-mm-DD HH:MM:SS'),code));
end
    
cb = colorbar;
title(cb,'\Delta\phi [\circ]');
set(ax,'layer','top');
set(ax,'TickDir','both');
set(ax,'FontSize',12);
set(ax,'CLim',[-180,180]);
set(ax,'XMinorTick','on','YMinorTick','on');
% Printout statistics
yy=axis;
y_min=yy(3)-70;
text(0.1,y_min-4,sprintf('SNR_t_r: %.2f dB',snr_tr));
if exist('pd','var') && length(pd)>1
    text(1.7,y_min,sprintf('O: %0.1f \x00B1 %0.1f',pd(1).mean,s_coef*pd(1).sigma));
    text(0.1,y_min-27,sprintf('f_\\sigma: %.1f',s_coef));
    text(1.7,y_min-23,sprintf('X: %0.1f \x00B1 %0.1f',pd(2).mean,s_coef*pd(2).sigma));
end

set(ax,'FontSize',18);
ti=get(ax,'TightInset');
cb=get(cb,'Position');
ti(3)=cb(3);
set(ax,'LooseInset',ti);
set(f1,'PaperUnits','points');
set(f1,'PaperPosition',[0 0 800 600]);
end