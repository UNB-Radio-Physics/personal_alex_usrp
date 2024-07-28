% Calculate and plot distributions and histograms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% THIS IS TEMPLATE ONLY NECESSARY TO EDIT FOR PARTICULAR DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% clear variables
clear

% initial parameters and flags
mat_p_folder='c:/data_comp/'; % mat-data folder
mat_p_name = '16bit_distr_all.mat'; % input mat-file name
mat_p_name_out = '16bit_distr_all_out.mat'; % output mat-file name
lShowSigma = false; % Show sigma ?

% preplot figures
f1 = figure(1);
f2 = figure(2);
f3 = figure(3);
clf(f1);
clf(f2);
clf(f3);

% load data
load([mat_p_folder mat_p_name]);

% Convert time range for MODIS

M1 = 1;
M2 = 328;
%  
% M1 = 329;
% M2 = 431;
% 
% M1 = 432;
% M2 = 796;

% M1 = 1;
% M2 = 796;

Nmat_m = M2-M1+1;
distrAp12_m = distrAp12_m(M1:M2,:);
Mtrx1_m = Mtrx1_m(M1:M2,:);
Mtrx2_m = Mtrx2_m(M1:M2,:);
utcAp_m = utcAp_m(M1:M2,1);

U1 = 1;
U2 = 206;
% 
% U1 = 207;
% U2 = 227;
% 
% U1 = 228;
% U2 = 428;
% 
% U1 = 1;
% U2 = 428;

Nmat_u = U2-U1+1;
distrAp12_u = distrAp12_u(U1:U2,:);
Mtrx1_u = Mtrx1_u(U1:U2,:);
Mtrx2_u = Mtrx2_u(U1:U2,:);
utcAp_u = utcAp_u(U1:U2,1);

sTimeTitle = '2024 June 01(00:00UT)-06(19:30UT), ';
% sTimeTitle = '2024 June 06(19:30UT)-07(13:46UT), ';
% sTimeTitle = '2024 June 07(13:46UT)-12(24:00UT), ';
% sTimeTitle = '2024 June 01(00:00UT)-12(24:00UT), ';

% Set additional parameters
Nmat_up_12 = 550;
NsmtU = 15;
NsmtM = 33;
NsmtUp = 23;

% Set atrefacts soundinds to NaN
% artN_m = [402 497 533 654 655 656 702 763];
artN_m = [];
% artN_u = [4 68 99 100 101 105 106 147 148 156 157 199 202 228 288 289 347 372 373 374 377 392 399 404];
artN_u = [4 68 99 100 101 105 106 147 148 156 157 199 202];
%artN_u = [];
artN_up = [96 154 155 156 157 158 159 160 161 190 246 274 352 355 415 480 511];
distrAp12_m(artN_m,:) = NaN;
distrAp12_u(artN_u,:) = NaN;
distrAp12_up(artN_up,:) = NaN;
distrAp34_up(artN_up,:) = NaN;
Mtrx1_m(artN_m,:) = NaN;
Mtrx2_m(artN_m,:) = NaN;
Mtrx1_u(artN_u,:) = NaN;
Mtrx2_u(artN_u,:) = NaN;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot variations of pahase differences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NIon2
figure(f1)
% Plot distributions for MODIS June 01-12
% smoothing data
for j=1:4
    distrAp12_ms(:,j) = smooth(distrAp12_m(:,j),NsmtM);
end
distrAp12_mm = mean(distrAp12_ms,1);

% plot distributions MODIS June
subplot(2,2,4);
% convert to datetime
utcAp_dt_m = datetime(utcAp_m,'ConvertFrom','datenum');
% plot lower distribition
plot(utcAp_dt_m,distrAp12_m(:,1),'c',utcAp_dt_m,distrAp12_ms(:,1),'b');
hold on;
if lShowSigma
    plot(utcAp_dt_m,distrAp12_ms(:,1)+distrAp12_ms(:,3),'k',...
         utcAp_dt_m,distrAp12_ms(:,1)-distrAp12_ms(:,3),'k');
end
% plot upper distribition
plot(utcAp_dt_m,distrAp12_m(:,2),'m',utcAp_dt_m,distrAp12_ms(:,2),'r');
if lShowSigma
    plot(utcAp_dt_m,distrAp12_ms(:,2)+distrAp12_ms(:,4),'k',...
         utcAp_dt_m,distrAp12_ms(:,2)-distrAp12_ms(:,4),'k');
end
hold off;
% format graph
ylim([-180,180]);
yticks(-180:30:180);
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'MODIS distributions (Ch2-Ch3)'],'Color','red');
xlabel('Dates of year 2024','Color','red');
ylabel('Phase, Deg','Color','red');
grid on;

% Plot distributions for USRP June 01-12
% smoothing data
for j=1:4
    distrAp12_us(:,j) = smooth(distrAp12_u(:,j),NsmtU);
end
distrAp12_um = mean(distrAp12_us,1);

% plot distributions USRP June 01-12 Ch0-1
subplot(2,2,2);
% convert to datetime
utcAp_dt_u = datetime(utcAp_u,'ConvertFrom','datenum');
% plot lower distribition
plot(utcAp_dt_u,distrAp12_u(:,1),'c',utcAp_dt_u,distrAp12_us(:,1),'b');
hold on;
if lShowSigma
    plot(utcAp_dt_u,distrAp12_us(:,1)+distrAp12_us(:,3),'k',...
         utcAp_dt_u,distrAp12_us(:,1)-distrAp12_us(:,3),'k');
end
% plot upper distribition
plot(utcAp_dt_u,distrAp12_u(:,2),'m',utcAp_dt_u,distrAp12_us(:,2),'r');
if lShowSigma
    plot(utcAp_dt_u,distrAp12_us(:,2)+distrAp12_us(:,4),'k',...
         utcAp_dt_u,distrAp12_us(:,2)-distrAp12_us(:,4),'k');
end
hold off;
% format graph
ylim([-180,180]);
yticks(-180:30:180);
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'USRP distributions (Ch0-Ch1)']);
xlabel('Dates of year 2024');
ylabel('Phase, Deg');
grid on;

% Plot distributions for USRP March 01-12
% Convert data arrays to 12 days
utcAp_up = utcAp_up(1:Nmat_up_12);
distrAp12_up = distrAp12_up(1:Nmat_up_12,:);
distrAp34_up = distrAp34_up(1:Nmat_up_12,:);

% smoothing data for March 01-12
for j=1:4
    distrAp12_ups(:,j) = smooth(distrAp12_up(:,j),NsmtUp);
    distrAp34_ups(:,j) = smooth(distrAp34_up(:,j),NsmtUp);
end
distrAp12_upm = mean(distrAp12_ups,1);
distrAp34_upm = mean(distrAp34_ups,1);

% plot distributions Ch0-1
subplot(2,2,1);
% convert to datetime
utcAp_dt_up = datetime(utcAp_up,'ConvertFrom','datenum');
% plot lower distribition
plot(utcAp_dt_up,distrAp12_up(:,1),'c',utcAp_dt_up,distrAp12_ups(:,1),'b');
hold on;
if lShowSigma
    plot(utcAp_dt_up,distrAp12_ups(:,1)+distrAp12_ups(:,3),'k',...
         utcAp_dt_up,distrAp12_ups(:,1)-distrAp12_ups(:,3),'k');
end
% plot upper distribition
plot(utcAp_dt_up,distrAp12_up(:,2),'m',utcAp_dt_up,distrAp12_ups(:,2),'r');
if lShowSigma
    plot(utcAp_dt_up,distrAp12_ups(:,2)+distrAp12_ups(:,4),'k',...
         utcAp_dt_up,distrAp12_ups(:,2)-distrAp12_ups(:,4),'k');
end
hold off;
% format graph
ylim([-180,180]);
yticks(-180:30:180);
xticks(datetime(2024,03,01,0,0,0):days(1):datetime(2024,03,12,24,0,0));
title('2024 March 01-12, USRP distributions (Ch0-Ch1)');
xlabel('Dates of year 2024');
ylabel('Phase, Deg');
grid on;

% plot distributions Ch2-3
subplot(2,2,3);
% % convert to datetime
% utcAp_dt_up = datetime(utcAp_up,'ConvertFrom','datenum');
% plot upper distribition
plot(utcAp_dt_up,distrAp34_up(:,1),'c',utcAp_dt_up,distrAp34_ups(:,1),'b');
hold on;
if lShowSigma
    plot(utcAp_dt_up,distrAp34_ups(:,1)+distrAp34_ups(:,3),'k',...
         utcAp_dt_up,distrAp34_ups(:,1)-distrAp34_ups(:,3),'k');
end
% plot upper distribition
plot(utcAp_dt_up,distrAp34_up(:,2),'m',utcAp_dt_up,distrAp34_ups(:,2),'r');
if lShowSigma
    plot(utcAp_dt_up,distrAp34_ups(:,2)+distrAp34_ups(:,4),'k',...
         utcAp_dt_up,distrAp34_ups(:,2)-distrAp12_ups(:,4),'k');
end
hold off;
% format graph
ylim([-180,180]);
yticks(-180:30:180);
xticks(datetime(2024,03,01,0,0,0):days(1):datetime(2024,03,12,24,0,0));
title('2024 March 01-12, USRP distributions 1-12 March(Ch2-Ch3)');
xlabel('Dates of year 2024');
ylabel('Phase, Deg');
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot histograms with mean substruction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(f2);

% USRP March 1-12 (Ch 0-1)
subplot(2,2,1)
dEdges_u = 5;
nEdgesP2_u = 10;
edges_upm12(:,1) = (distrAp12_upm(1)-dEdges_u*(0.5+nEdgesP2_u)):dEdges_u:(distrAp12_upm(1)+dEdges_u*(0.5+nEdgesP2_u));
edges_upm12(:,2) = (distrAp12_upm(2)-dEdges_u*(0.5+nEdgesP2_u)):dEdges_u:(distrAp12_upm(2)+dEdges_u*(0.5+nEdgesP2_u));
histAp12_up(1,1) = histogram(distrAp12_up(:,1)-distrAp12_ups(:,1)+distrAp12_upm(1),edges_upm12(:,1),'FaceColor','b'); 
hold on
histAp12_up(2,1) = histogram(distrAp12_up(:,2)-distrAp12_ups(:,2)+distrAp12_upm(2),edges_upm12(:,2),'FaceColor','r'); 
hold off
xlim([-180 180]);
xticks(-180:30:180);
title('2024 March 01-12, USRP distributions (Ch0-Ch1)');
xlabel('\Delta\Phi, Deg');
ylabel('Number of cases');
grid on;


% USRP March 1-12 (Ch 2-3)
subplot(2,2,2)
dEdges_u = 5;
nEdgesP2_u = 10;
edges_upm34(:,1) = (distrAp34_upm(1)-dEdges_u*(0.5+nEdgesP2_u)):dEdges_u:(distrAp34_upm(1)+dEdges_u*(0.5+nEdgesP2_u));
edges_upm34(:,2) = (distrAp34_upm(2)-dEdges_u*(0.5+nEdgesP2_u)):dEdges_u:(distrAp34_upm(2)+dEdges_u*(0.5+nEdgesP2_u));
histAp34_up(1,1) = histogram(distrAp34_up(:,1)-distrAp34_ups(:,1)+distrAp34_upm(1),edges_upm34(:,1),'FaceColor','b'); 
hold on
histAp34_up(2,1) = histogram(distrAp34_up(:,2)-distrAp34_ups(:,2)+distrAp34_upm(2),edges_upm34(:,2),'FaceColor','r'); 
hold off
xlim([-180 180]);
xticks(-180:30:180);
title('2024 March 01-12, USRP distributions (Ch2-Ch3)');
xlabel('\Delta\Phi, Deg');
ylabel('Number of cases');
grid on;

% USRP June 1-12
subplot(2,2,3)
dEdges_u = 5;
nEdgesP2_u = 10;
edges_m12(:,1) = (distrAp12_mm(1)-dEdges_u*(0.5+nEdgesP2_u)):dEdges_u:(distrAp12_mm(1)+dEdges_u*(0.5+nEdgesP2_u));
edges_m12(:,2) = (distrAp12_mm(2)-dEdges_u*(0.5+nEdgesP2_u)):dEdges_u:(distrAp12_mm(2)+dEdges_u*(0.5+nEdgesP2_u));
histAp12_u(1,1) = histogram(distrAp12_u(:,1)-distrAp12_us(:,1)+distrAp12_um(1),edges_m12(:,1),'FaceColor','b'); 
hold on
histAp12_u(2,1) = histogram(distrAp12_u(:,2)-distrAp12_us(:,2)+distrAp12_um(2),edges_m12(:,2),'FaceColor','r'); 
hold off
xlim([-180 180]);
xticks(-180:30:180);
title([sTimeTitle 'USRP distributions (Ch0-Ch1)']);
xlabel('\Delta\Phi, Deg');
ylabel('Number of cases');
grid on;

% MODIS June 1-12
subplot(2,2,4)
dEdges_m = 5;
nEdgesP2_m = 10;
edges_m12(:,1) = (distrAp12_mm(1)-dEdges_m*(0.5+nEdgesP2_m)):dEdges_m:(distrAp12_mm(1)+dEdges_m*(0.5+nEdgesP2_m));
edges_m12(:,2) = (distrAp12_mm(2)-dEdges_m*(0.5+nEdgesP2_m)):dEdges_m:(distrAp12_mm(2)+dEdges_m*(0.5+nEdgesP2_m));
histAp12_m(1,1) = histogram(distrAp12_m(:,1)-distrAp12_ms(:,1)+distrAp12_mm(1),edges_m12(:,1),'FaceColor','b'); 
hold on
histAp12_m(2,1) = histogram(distrAp12_m(:,2)-distrAp12_ms(:,2)+distrAp12_mm(2),edges_m12(:,2),'FaceColor','r'); 
hold off
xlim([-180 180]);
xticks(-180:30:180);
title([sTimeTitle 'MODIS distributions (Ch2-Ch3)']);
xlabel('\Delta\Phi, Deg');
ylabel('Number of cases');
grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot difference variations of pahase differences
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NIon2
figure(f3)

% plot distributions MODIS June Ch3-Ch2 difference
subplot(2,2,4);
% convert to datetime
utcAp_dt_m = datetime(utcAp_m,'ConvertFrom','datenum');
% plot lower distribition
plot(utcAp_dt_m,distrAp12_m(:,2)-distrAp12_m(:,1),'r');
% format graph
ylim([0,360]);
yticks(0:30:360);
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'MODIS distributions Ch3-Ch2 difference'],'Color','red');
xlabel('Dates of year 2024','Color','red');
ylabel('Phase, Deg','Color','red');
grid on;

% plot distributions USRP June 01-12 Ch1-Ch0 difference
subplot(2,2,2);
% convert to datetime
utcAp_dt_u = datetime(utcAp_u,'ConvertFrom','datenum');
% plot lower distribition
plot(utcAp_dt_u,distrAp12_u(:,2)-distrAp12_u(:,1),'k');
% format graph
ylim([0,360]);
yticks(0:30:360);
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'USRP distributions Ch1-Ch0 ddifference']);
xlabel('Dates of year 2024');
ylabel('Phase, Deg');
grid on;

% Plot distributions for USRP March 01-12 Ch1-Ch0 difference
subplot(2,2,1);
% convert to datetime
utcAp_dt_up = datetime(utcAp_up,'ConvertFrom','datenum');
% plot lower distribition
plot(utcAp_dt_up,distrAp12_up(:,2)-distrAp12_up(:,1),'k');
% format graph
ylim([0,360]);
yticks(0:30:360);    
xticks(datetime(2024,03,01,0,0,0):days(1):datetime(2024,03,12,24,0,0));
title('2024 March 01-12, USRP distributions Ch1-Ch0 difference)');
xlabel('Dates of year 2024');
ylabel('Phase, Deg');
grid on;

% plot distributions Ch3-2 difference
subplot(2,2,3);
plot(utcAp_dt_up,distrAp34_up(:,2)-distrAp34_up(:,1),'k');
% format graph
ylim([0,360]);
yticks(0:30:360);
xticks(datetime(2024,03,01,0,0,0):days(1):datetime(2024,03,12,24,0,0));
title('2024 March 01-12, USRP distributions Ch3-Ch2 difference)');
xlabel('Dates of year 2024');
ylabel('Phase, Deg');
grid on;

% Save figures and data
saveas(f1,[mat_p_folder 'Distrinutions.png'],'png');
saveas(f1,[mat_p_folder 'Distrinutions.fig'],'fig');
saveas(f2,[mat_p_folder 'Histograms.png'],'png');
saveas(f2,[mat_p_folder 'Histograms.fig'],'fig');
saveas(f3,[mat_p_folder 'DistrinutionsDiff.png'],'png');
saveas(f3,[mat_p_folder 'DistrinutionsDiff.fig'],'fig');
clear('f1','f2','f3');
save([mat_p_folder mat_p_name_out]);

