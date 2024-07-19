function [f]=plot_dopplerogram(freq,hght,amp,dopp,code,dt)

    snr_threshold=6;

    f=figure;
    pwr=20*log10(abs(amp));
    pwr=pwr-repmat(mode(round(pwr)),size(pwr,1),1)-2;
    ind=pwr<=snr_threshold;
    dopp(ind)=NaN;
    
    h=pcolor(single(freq)/1e6,hght,dopp);
    
    % Printout info
    yy=axis;
    y_min=double(yy(3)-70);
    text(3.5,y_min,code);
    
    % Configure plot appearance
    colormap jet;
    set(h, 'EdgeColor', 'none');
    xlabel('Freq [MHz]');
    ylabel('h'' [km]');
    title(datestr(dt,'YYYY-mm-DD HH:MM:SS'));
    cb = colorbar;
    title(cb,'Fd [Hz]');
    set(gca,'layer','top');
    set(gca,'TickDir','both');
    set(gca,'FontSize',12);
    
    %set(gca,'CLim',[-5,30]);
    set(gca,'XMinorTick','on','YMinorTick','on');
    
    set(gca,'FontSize',18);
    ti=get(gca,'TightInset');
    cb=get(cb,'Position');
    ti(3)=cb(3);
    set(gca,'LooseInset',ti);
    set(gcf,'PaperUnits','points');
    set(gcf,'PaperPosition',[0 0 800 600]);

end
