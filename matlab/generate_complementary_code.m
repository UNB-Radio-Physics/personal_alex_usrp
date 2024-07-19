function [odd_pulse, even_pulse, sps] = generate_complementary_code(codeLength,saveToFile,plotCode,lMODIS,lpulse_shaping)
% Generates complementary code of the specified length

if strcmp(codeLength,'128b')
    % 128 bit binary
    odd  = [1;1;-1;-1;-1;-1;-1;-1;-1;1;-1;1;1;-1;-1;1;1;1;-1;-1;1;1;1;1;-1;1;-1;1;-1;1;1;-1;-1;-1;1;1;1;1;1;1;1;-1;1;-1;-1;1;1;-1;1;1;-1;-1;1;1;1;1;-1;1;-1;1;-1;1;1;-1;1;1;-1;-1;-1;-1;-1;-1;-1;1;-1;1;1;-1;-1;1;1;1;-1;-1;1;1;1;1;-1;1;-1;1;-1;1;1;-1;1;1;-1;-1;-1;-1;-1;-1;-1;1;-1;1;1;-1;-1;1;-1;-1;1;1;-1;-1;-1;-1;1;-1;1;-1;1;-1;-1;1;];
    even = [-1;-1;1;1;1;1;1;1;1;-1;1;-1;-1;1;1;-1;-1;-1;1;1;-1;-1;-1;-1;1;-1;1;-1;1;-1;-1;1;1;1;-1;-1;-1;-1;-1;-1;-1;1;-1;1;1;-1;-1;1;-1;-1;1;1;-1;-1;-1;-1;1;-1;1;-1;1;-1;-1;1;1;1;-1;-1;-1;-1;-1;-1;-1;1;-1;1;1;-1;-1;1;1;1;-1;-1;1;1;1;1;-1;1;-1;1;-1;1;1;-1;1;1;-1;-1;-1;-1;-1;-1;-1;1;-1;1;1;-1;-1;1;-1;-1;1;1;-1;-1;-1;-1;1;-1;1;-1;1;-1;-1;1;];
    sps = 1;
elseif strcmp(codeLength,'64q')
    % 64 bit quadruple
    odd_r = [1;-1;1;1;0; 0;0;0;-1;1;1;1;0; 0; 0; 0;-1;-1;-1;1; 0; 0; 0;0;1;1;-1;1; 0; 0;0; 0;-1;1;-1;-1; 0;0; 0; 0;1;-1;-1;-1; 0;0;0;0;-1;-1;-1;1; 0; 0; 0;0;1;1;-1;1;0;0;0;0]; 
    odd_i = [0; 0;0;0;1;-1;1;1; 0;0;0;0;1;-1;-1;-1; 0; 0; 0;0;-1;-1;-1;1;0;0; 0;0;-1;-1;1;-1; 0;0; 0; 0;-1;1;-1;-1;0; 0; 0; 0;-1;1;1;1; 0; 0; 0;0;-1;-1;-1;1;0;0; 0;0;-1;-1;1;-1;]; 
    odd   = complex(odd_r,odd_i);
    
    even_r = [-1;1;-1;-1; 0;0; 0; 0;1;-1;-1;-1; 0;0;0;0;1;1;1;-1;0;0;0; 0;-1;-1;1;-1;0;0; 0;0;-1;1;-1;-1; 0;0; 0; 0;1;-1;-1;-1; 0;0;0;0;-1;-1;-1;1; 0; 0; 0;0;1;1;-1;1;0;0;0;0];
    even_i = [ 0;0; 0; 0;-1;1;-1;-1;0; 0; 0; 0;-1;1;1;1;0;0;0; 0;1;1;1;-1; 0; 0;0; 0;1;1;-1;1; 0;0; 0; 0;-1;1;-1;-1;0; 0; 0; 0;-1;1;1;1; 0; 0; 0;0;-1;-1;-1;1;0;0; 0;0;-1;-1;1;-1;];
    even   = complex(even_r,even_i);
    sps = 2;
elseif strcmp(codeLength,'64b')
    % 64 bit binary
    odd  = [-1;-1;+1;-1;+1;-1;-1;-1;+1;+1;-1;+1;+1;-1;-1;-1;-1;-1;+1;-1;+1;-1;-1;-1;-1;-1;+1;-1;-1;+1;+1;+1;-1;-1;+1;-1;+1;-1;-1;-1;+1;+1;-1;+1;+1;-1;-1;-1;+1;+1;-1;+1;-1;+1;+1;+1;+1;+1;-1;+1;+1;-1;-1;-1;];
    even = [+1;+1;-1;+1;-1;+1;+1;+1;-1;-1;+1;-1;-1;+1;+1;+1;+1;+1;-1;+1;-1;+1;+1;+1;+1;+1;-1;+1;+1;-1;-1;-1;-1;-1;+1;-1;+1;-1;-1;-1;+1;+1;-1;+1;+1;-1;-1;-1;+1;+1;-1;+1;-1;+1;+1;+1;+1;+1;-1;+1;+1;-1;-1;-1;];
    sps = 2;
elseif strcmp(codeLength,'32q')
    % 32 bit quadruple 
    odd_r = [1;-1;1;1;0; 0;0;0;-1;1;1;1;0; 0; 0; 0;-1;-1;-1;1; 0; 0; 0;0;1;1;-1;1; 0; 0;0; 0]; 
    odd_i = [0; 0;0;0;1;-1;1;1; 0;0;0;0;1;-1;-1;-1; 0; 0; 0;0;-1;-1;-1;1;0;0; 0;0;-1;-1;1;-1]; 
    odd   = complex(odd_r,odd_i);
    
    even_r = [-1;1;-1;-1; 0;0; 0; 0;1;-1;-1;-1; 0;0;0;0;-1;-1;-1;1; 0; 0; 0;0;1;1;-1;1; 0; 0;0; 0];
    even_i = [ 0;0; 0; 0;-1;1;-1;-1;0; 0; 0; 0;-1;1;1;1; 0; 0; 0;0;-1;-1;-1;1;0;0; 0;0;-1;-1;1;-1];
    even   = complex(even_r,even_i);
    sps = 3;
elseif strcmp(codeLength,'32b')
% 32 bit binary
    if ~lMODIS
        odd  = [1;1;1;-1;1;1;-1;1;1;1;1;-1;-1;-1;1;-1; 1; 1; 1;-1; 1; 1;-1; 1;-1;-1;-1; 1; 1; 1;-1; 1];
        even = [1;1;1;-1;1;1;-1;1;1;1;1;-1;-1;-1;1;-1;-1;-1;-1; 1;-1;-1; 1;-1; 1; 1; 1;-1;-1;-1; 1;-1];
        sps = 3;
    else %%%%%%%%%%%%%%%%%% FOR MODIS
        % 32 bit binary 
        odd  = [-1;-1;-1;-1;-1;-1; 1; 1;-1;-1;-1;-1; 1; 1;-1;-1;  -1;-1;-1;-1;-1;-1; 1; 1; 1; 1; 1; 1;-1;-1; 1; 1];
        even = [-1;-1;-1;-1;-1;-1; 1; 1;-1;-1;-1;-1; 1; 1;-1;-1;   1; 1; 1; 1; 1; 1;-1;-1;-1;-1;-1;-1; 1; 1;-1;-1];
        sps = 3;
    % figure;
    % plot(odd);
    % hold on;
    % plot(even);
    % title('32')

    end %%%%%%%%%%%%%%%%%% FOR MODIS
elseif strcmp(codeLength,'24q')    
    % 24 bit quadruple
    odd_r = [1; 0; -1; 0; 1; 0; -1; 0; -1;  0; 1;  0; 1; 0; 1;  0; 0; -1; 0; 1; 1; 0; 1;  0]; 
    odd_i = [0; 1;  0; 1; 0; 1;  0; 1;  0; -1; 0; -1; 0; 1; 0; -1; 1;  0; 1; 0; 0; 1; 0; -1]; 
    odd   = complex(odd_r,odd_i);
    
    even_r = [-1; 0; 1;  0; 0; -1;  0; -1; -1;  0; 1;  0; -1;  0; -1;  0; 1; 0; 1;  0; 1; 0; 1;  0];
    even_i = [0; -1; 0; -1; 1;  0; -1;  0;  0; -1; 0; -1;  0; -1;  0;  1; 0; 1; 0; -1; 0; 1; 0; -1];
    even   = complex(even_r,even_i);

    sps = 4;
elseif strcmp(codeLength,'16q')
    % 16 bit quadruple 
    odd_r = [1; 0; -1; 0; 1; 0; -1; 0; 1; 0; 1;  0; -1;  0; -1; 0]; 
    odd_i = [0; 1;  0; 1; 0; 1;  0; 1; 0; 1; 0; -1;  0; -1;  0; 1]; 
    odd   = complex(odd_r,odd_i);
    
    even_r = [1; 0; -1; 0; -1;  0; 1;  0; 1; 0; 1;  0; 1; 0; 1;  0];
    even_i = [0; 1;  0; 1;  0; -1; 0; -1; 0; 1; 0; -1; 0; 1; 0; -1];
    even   = complex(even_r,even_i);

    sps = 6;
elseif strcmp(codeLength,'16b')
    if ~lMODIS
    % 16 bit binary
        odd  = [1;1;-1;1;1;1;1;-1; 1;-1;-1;-1;1;-1;1;1;];
        even = [1;1;-1;1;1;1;1;-1; -1;1;1;1;-1;1;-1;-1];
        sps = 6;
    else %%%%%%%%%%%%%%%%%% FOR MODIS
        % 16 bit binary 
        odd  = [-1;-1;-1; 1;-1;-1; 1;-1;  -1;-1;-1; 1; 1; 1;-1; 1;];
        even = [-1;-1;-1; 1;-1;-1; 1;-1;   1; 1; 1;-1;-1;-1; 1;-1;];
        sps = 6;
    end %%%%%%%%%%%%%%%%%% FOR MODIS
    sps = 6;
    % figure;
    % plot(odd);
    % hold on;
    % plot(even);
    % title('16')

elseif strcmp(codeLength,'08q')
    % 8 bit quadruple 
%     odd_r = [1; -1; 0; 0;  0; 0; -1; -1]; 
%     odd_i = [0;  0; 1; 1; -1; 1;  0;  0]; 
%     odd   = complex(odd_r,odd_i);
%     
%     even_r = [-1; -1; 0;  0;  0;  0; 1; -1];
%     even_i = [ 0;  0; 1; -1; -1; -1; 0;  0];
%     even   = complex(even_r,even_i);
% 
%     sps = 12;
% 8 bit quadruple
    odd_r = [1;  0; -1; 0;  1; 0; 1; 0];
    odd_i = [0;  1;  0; 1;  0; 1; 0;-1];
    odd   = complex(odd_r,odd_i);
 
    even_r = [ 1;  0; -1;  0; -1;  0; -1; 0];
    even_i = [ 0;  1;  0;  1;  0; -1; 0; 1];
    even   = complex(even_r,even_i);

    sps = 12;
elseif strcmp(codeLength,'08b')
    % 8 bit binary
    odd  = [1;1;1;-1;1;1;-1;1;];
    even = [1;1;1;-1;-1;-1;1;-1;];
    sps = 12;
else
    % 4 bit binary
    odd  = [1;1;1;-1;];
    even = [1;1;-1;1;];
    sps = 22;
end

ampl = 32768/1 - 1;

% Symbol span
sym_span=2;

% Pulse shape
if lpulse_shaping
    b = rcosdesign(1,sym_span,sps);
    odd_flt = single(upfirdn(odd,b,sps));
    even_flt = single(upfirdn(even,b,sps));
else
    for j=1:length(odd)
        odd_flt((j-1)*sps+1:j*sps,1) = odd(j);
        even_flt((j-1)*sps+1:j*sps,1) = even(j);
    end
end

% Normalize amplitude
odd_flt = odd_flt/max(odd_flt);
even_flt = even_flt/max(even_flt);

% Scale amplitude
odd_pulse = ampl*odd_flt;
even_pulse = ampl*even_flt;

% Fill last symbol with zeroes (TODO: make sure it's needed)
if lpulse_shaping
    sz = size(odd_flt,1);
    tail = 18 - mod(sz,sps);
    odd_flt(sz+1:sz + tail) = 0;
    
    sz = size(even_flt,1);
    tail = 18 - mod(sz,sps);
    even_flt(sz+1:sz + tail) = 0;
end

% Convert to complex number and set amplitude.
if (isreal(odd_flt))
    odd_flt(1:2:size(odd_flt,1)*2) = ampl*odd_flt;
    odd_flt(2:2:size(odd_flt,1)+1) = 0;
    
    even_flt(1:2:size(even_flt,1)*2) = ampl*even_flt;
    even_flt(2:2:size(even_flt,1)+1) = 0;
else
    tmp = odd_flt;
    odd_flt(1:2:size(odd_flt,1)*2) = ampl*real(tmp);
    odd_flt(2:2:size(odd_flt,1)+1) = ampl*imag(tmp);
    
    tmp = even_flt;
    even_flt(1:2:size(even_flt,1)*2) = ampl*real(tmp);
    even_flt(2:2:size(even_flt,1)+1) = ampl*imag(tmp);
end

% Plot code
if plotCode
    figure;
    plot(odd_flt(1:2:end));
    hold on;
    plot(even_flt(1:2:end));
end

% Save to file
if saveToFile
    f_odd = fopen('tx_buff_odd.dat','w+');
    fwrite(f_odd,odd_flt,'int16');
    fclose(f_odd);

    f_even = fopen('tx_buff_even.dat','w+');
    fwrite(f_even,even_flt,'int16');
    fclose(f_even);
end