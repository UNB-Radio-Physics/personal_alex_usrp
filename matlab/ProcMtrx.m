% Calculate difference of the parameters for two ionogram data sets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% THIS IS TEMPLATE ONLY NECESSARY TO EDIT FOR PARTICULAR DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% clear variables
clear

% initial parameters and flags
mat_p_folder='c:/data_comp/'; % mat-data folder
mat_p_name = '16bit_distr_all.mat'; % input mat-file name
mat_p_name_out = '16bit_distr_all_Mtrx_out.mat'; % output mat-file name


% lShowSigma = false; % Show sigma ?

% preplot figures
f1 = figure(1);
f2 = figure(2);
clf(f1);
clf(f2);

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
% 
% M1 = 1;
% M2 = 796;
Nmat_m = M2-M1+1;
distrAp12_m = distrAp12_m(M1:M2,:);
Mtrx1_m = Mtrx1_m(M1:M2,:);
Mtrx2_m = Mtrx2_m(M1:M2,:);
utcAp_m = utcAp_m(M1:M2,1);

sTimeTitle = '2024 June 01(00:00UT)-06(19:30UT), ';
% sTimeTitle = '2024 June 06(19:30UT)-07(13:46UT), ';
% sTimeTitle = '2024 June 07(13:46UT)-12(24:00UT), ';
% sTimeTitle = '2024 June 01(00:00UT)-12(24:00UT), ';

% convert to datetime
utcAp_dt_m = datetime(utcAp_m,'ConvertFrom','datenum');
utcAp_dt_u = datetime(utcAp_u,'ConvertFrom','datenum');

% 
% % Set additional parameters
% Nmat_up_12 = 550;
% NsmtU = 15;
% NsmtM = 33;
% NsmtUp = 23;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot variations of Metrix for June 01-12
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%N
figure(f1)

% plot distributions of median
subplot(2,2,1);
plot(utcAp_dt_u,Mtrx1_u(:,1),'r',utcAp_dt_m,Mtrx2_m(:,1),'b');
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'Median (MODIS-blue, USRP-red)']);
xlabel('Dates of year 2024');
ylabel('Median, a.u.');
legend('USRP Ch0','MODIS Ch1');
grid on;

% plot distributions of mean
subplot(2,2,3);
plot(utcAp_dt_u,Mtrx1_u(:,2),'r',utcAp_dt_m,Mtrx2_m(:,2),'b');
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'Mean (MODIS-blue, USRP-red)']);
xlabel('Dates of year 2024');
ylabel('Mean, a.u.');
legend('USRP Ch0','MODIS Ch1');
grid on;

% plot distributions of Ntot
subplot(2,2,2);
plot(utcAp_dt_u,Mtrx1_u(:,3),'r',utcAp_dt_m,Mtrx2_m(:,3),'b');
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'Ntot (MODIS-blue, USRP-red)']);
xlabel('Dates of year 2024');
ylabel('Ntot, a.u.');
legend('USRP Ch0','MODIS Ch1');
grid on;

% plot distributions of CumSum
subplot(2,2,4);
plot(utcAp_dt_u,Mtrx1_u(:,4),'r',utcAp_dt_m,Mtrx2_m(:,4),'b');
xticks(datetime(2024,06,01,0,0,0):days(1):datetime(2024,06,12,24,0,0));
title([sTimeTitle 'CumSum (MODIS-blue, USRP-red)']);
xlabel('Dates of year 2024');
ylabel('CumSum, a.u.');
legend('USRP Ch0','MODIS Ch1');
grid on;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot and calculate daily variations of Metrix for June 01-12
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(f2)

% MODIS
for j=0:23
    median_u(j+1,1) = mean(Mtrx1_u(find(hour(utcAp_dt_u)==j),1),'omitnan');
    mean_u(j+1,1) = mean(Mtrx1_u(find(hour(utcAp_dt_u)==j),2),'omitnan');
    Ntot_u(j+1,1) = mean(Mtrx1_u(find(hour(utcAp_dt_u)==j),3),'omitnan');
    CumSum_u(j+1,1) = mean(Mtrx1_u(find(hour(utcAp_dt_u)==j),4),'omitnan');
    median_m(j+1,1) = mean(Mtrx2_m(find(hour(utcAp_dt_m)==j),1),'omitnan');
    mean_m(j+1,1) = mean(Mtrx2_m(find(hour(utcAp_dt_m)==j),2),'omitnan');
    Ntot_m(j+1,1) = mean(Mtrx2_m(find(hour(utcAp_dt_m)==j),3),'omitnan');
    CumSum_m(j+1,1) = mean(Mtrx2_m(find(hour(utcAp_dt_m)==j),4),'omitnan');
end
UThour = 0:24;
median_u(end+1)=median_u(end);
median_m(end+1)=median_m(end);
mean_u(end+1)=mean_u(end);
mean_m(end+1)=mean_m(end);
Ntot_u(end+1)=Ntot_u(end);
Ntot_m(end+1)=Ntot_m(end);
CumSum_u(end+1)=CumSum_u(end);
CumSum_m(end+1)=CumSum_m(end);

% % plot distributions of median
% subplot(2,2,1);
% stairs(UThour,median_u,'r','LineWidth',2)
% hold on
% stairs(UThour,median_m,'b','LineWidth',2);
% hold off;
% xlim([0 24])
% xticks(0:24);
% title([sTimeTitle 'Daily Median (MODIS-blue, USRP-red)']);
% xlabel('Time UT, hours');
% ylabel('Median, dB');
% legend('USRP Ch0','MODIS Ch1','Location','best');
% grid on;

% plot distributions of mean
% subplot(2,2,3);
subplot(1,3,1);
stairs(UThour,mean_u,'r','LineWidth',2)
hold on
stairs(UThour,mean_m,'b','LineWidth',2);
hold off;
xlim([0 24])
xticks(0:24);
title([sTimeTitle 'Daily Mean (MODIS-blue, USRP-red)']);
xlabel('Time UT, hours');
ylabel('Mean, dB');
legend('USRP Ch0','MODIS Ch1','Location','best');
grid on;

% plot distributions of mean
% subplot(2,2,2);
subplot(1,3,2);
stairs(UThour,Ntot_u,'r','LineWidth',2)
hold on
stairs(UThour,Ntot_m,'b','LineWidth',2);
hold off;
xlim([0 24])
xticks(0:24);
title([sTimeTitle 'Daily Ntot (MODIS-blue, USRP-red)']);
xlabel('Time UT, hours');
ylabel('Ntot');
legend('USRP Ch0','MODIS Ch1','Location','best');
grid on;

% plot distributions of mean
% subplot(2,2,4);
subplot(1,3,3);
stairs(UThour,CumSum_u,'r','LineWidth',2)
hold on
stairs(UThour,CumSum_m,'b','LineWidth',2);
hold off;
xlim([0 24])
xticks(0:24);
title([sTimeTitle 'Daily CumSumt (MODIS-blue, USRP-red)']);
xlabel('Time UT, hours');
ylabel('CumSum');
legend('USRP Ch0','MODIS Ch1','Location','best');
grid on;

% Save figures and data
saveas(f1,[mat_p_folder 'Matrix_June07-12.png'],'png');
saveas(f1,[mat_p_folder 'Matrix_June07-12.fig'],'fig');
saveas(f2,[mat_p_folder 'Matrix_June07-12_Daily.png'],'png');
saveas(f2,[mat_p_folder 'Matrix_June07-12_Daily.fig'],'fig');
clear('f1','f2');
save([mat_p_folder mat_p_name_out]);

