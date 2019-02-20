function [c50, h_cut] = c50_calc( h, fs, budget_ms )
% calculation of the clarity index C50
% Input:
%   h:      impulse response (vector)
%   fs:     sampling frequency
%   budget_ms:  plus/minus portion around the peak, default [2.5 50]ms
% Output:
%   c50:    C50 in dB
%   h_cut:  the cutoff impulse response for processing
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin < 3
    budget_ms = [2.5, 50]; % 2.5ms before the peak and 50ms after
end

% determine the direct path position and the range +/-
h = h(:);
h_len = length(h);

% peak - 2.5ms (influence of the sampling) 
ind_minus = round(budget_ms(1)/1000*fs);

% peak + 50ms
ind_plus  = round(budget_ms(2)/1000*fs);
[~ , ind_max] = max(abs(h));

ind_start = ind_max - ind_minus;
ind_end   = ind_max + ind_plus;

if ind_start < 1
	ind_start = 1;
end

if ind_end > h_len
	ind_end = h_len;
	fprintf(sprintf('Warning: too short RIR, index %d already reach to length of RIR\n',ind_end));
end

% processed part of RIR
h_cut = h(ind_start:h_len);



% Obtain the direct path from the RIR
h_direct = h_cut(1:ind_end-ind_start+1);

% Obtain the indirect path from the RIR
h_reverb  = h_cut;
h_reverb(1:ind_end-ind_start+1)   = zeros(size(h_direct));


% Compute the DRR
c50  = 10*log10((sum(h_direct.^2)/sum(h_reverb.^2)));








