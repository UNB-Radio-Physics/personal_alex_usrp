% Make distributions for MODIS-USRP polarization mat data
% This distributions will be used for Phases calation and plotting by:
% ProcDistr.m, ProcMtrx.m - MatLab scripts

% clear workspace
clear

% all polarization files YYYYMMDD_hhmmss_p.mat have to be moved to this folder
mat_p_folder='C:\data_comp\usrp_mat_all_20240601-12\';
% coorect file name mask have to be used  
mat_p = dir([mat_p_folder '2024*p.mat']);
% output file name for arrays of distributtions
mat_p_out = '202406_distr_all_usrp.mat';

% Number of polarization mat-files in input folder
Nmat = size(mat_p,1);
NCh = 2;

% Loop to prepare distributions for all soundings
for j=1:Nmat

    % load soundings
    load([mat_p_folder mat_p(j).name]);
    % set distribution to NaN if only one peak exists 
    if any(isnan(distr_p12))
        distr_p12(:) = NaN;
    end
    % make arrays of distributions
    distrAp12(j,:) = distr_p12;
    Mtrx1(j,1) = Mtrx(1).median_pwr_gt;
    Mtrx1(j,2) = Mtrx(1).mean_pwr_gt;
    Mtrx1(j,3) = Mtrx(1).n_pwr_gt;
    Mtrx1(j,4) = Mtrx(1).lngth_pwr_gt;
    Mtrx2(j,1) = Mtrx(2).median_pwr_gt;
    Mtrx2(j,2) = Mtrx(2).mean_pwr_gt;
    Mtrx2(j,3) = Mtrx(2).n_pwr_gt;
    Mtrx2(j,4) = Mtrx(2).lngth_pwr_gt;
    
    % make array of distributions for channels 2,3 if any
    if exist('distr_p34') 
        NCh = 4;
        % set distribution to NaN if only one peak exists 
        if any(isnan(distr_p34))
            distr_p34(:) = NaN;
        end
        % make arrays of distributions
        distrAp34(j,:) = distr_p34;
        Mtrx3(j,1) = Mtrx(3).median_pwr_gt;
        Mtrx3(j,2) = Mtrx(3).mean_pwr_gt;
        Mtrx3(j,3) = Mtrx(3).n_pwr_gt;
        Mtrx3(j,4) = Mtrx(3).lngth_pwr_gt;
        Mtrx4(j,1) = Mtrx(4).median_pwr_gt;
        Mtrx4(j,2) = Mtrx(4).mean_pwr_gt;
        Mtrx4(j,3) = Mtrx(4).n_pwr_gt;
        Mtrx4(j,4) = Mtrx(4).lngth_pwr_gt;
    end

    % make array of DateNum in UTC
    utcAp(j,1) = utc;

end

% save output data file
if NCh == 2
    save([mat_p_folder mat_p_out],'utcAp','distrAp12','Mtrx1','Mtrx2');
else
    save([mat_p_folder mat_p_out],'utcAp','distrAp12','distrAp34','Mtrx1','Mtrx2','Mtrx3','Mtrx4');
end
