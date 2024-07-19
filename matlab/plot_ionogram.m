function [f,Mtrx]=plot_ionogram(freq,hght,amp,code,dt,lpulse_shaping)

    pwr=20*log10(abs(amp));
    pwr=pwr-repmat(mode(round(pwr)),size(pwr,1),1)-2;

    f=figure;
    h=pcolor(single(freq)/1e6,hght,pwr);

    % Printout SNR statistics
    snr_threshold=10;
    yy=axis;
    y_min=double(yy(3)-70);
    pwr_gt=pwr(pwr>snr_threshold);
    text(0.1,y_min,sprintf('Med: %.2f',median(pwr_gt)));
    text(1.5,y_min,sprintf('Mean: %.2f',mean(pwr_gt)));
    text(0.1,y_min-20,sprintf('Ntot: %d',length(pwr_gt)));
    text(1.5,y_min-20,sprintf('CumSum: %.2f',sum(pwr_gt)));
    if lpulse_shaping
        text(3.5,y_min-20,'pulse shaping ON');
    else
        text(3.5,y_min-20,'pulse shaping OFF');
    end
    text(3.5,y_min,code);
    Mtrx.median_pwr_gt = median(pwr_gt);
    Mtrx.mean_pwr_gt = mean(pwr_gt);
    Mtrx.n_pwr_gt = length(pwr_gt);
    Mtrx.lngth_pwr_gt = sum(pwr_gt);
    Mtrx.sum_pwr_gt = code;
    Mtrx.pls_sp = lpulse_shaping;

    % Configure plot appearance
    colormap jet;
    set(h, 'EdgeColor', 'none');
    xlabel('Freq [MHz]');
    ylabel('h'' [km]');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xlim([1 10]); % Set MaxFr to 10 MHz
    xticks(1:10);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    title(datestr(dt,'YYYY-mm-DD HH:MM:SS'));
    cb = colorbar;
    title(cb,'SNR [dB]');
    ca=gca;
    ca.Layer='top';
    ca.TickDir='both';

    ca.CLim=[-5,30];
    ca.XMinorTick='on';
    ca.YMinorTick='on';

    ca.FontSize=18;
    ti=ca.TightInset;
    ti(3)=cb.Position(3);
    ca.LooseInset=ti;
    f.PaperUnits='points';
    f.PaperPosition=[0 0 800 600];

end