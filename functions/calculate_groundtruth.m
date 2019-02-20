function [rt, elr] = calculate_groundtruth( h, fs, subband )
% calculate the ground truth of the reverberation time and early-to-late
% reverberation ratio based on the room impulse response
%
% Input:
%   h:      room impulse response (single channel)
%   fs:     sampling frequency
%   Optional
%           subband:  1: including the subband mode values based on
%           Gammatone filter bank; 0: without subband values
%
% Output:
%   rt:     RT ground truth (1) fullband, (2:end) subband
%   elr:    ELR ground truth (1) fullband, (2:end) subband
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    subband = 0; % without subband results
end

% fullband mode
[elr, h_cut] = c50_calc( h, fs );
[rt, ~] = t60_ir_nonlinfit(h_cut, fs, 0);

% subband
if subband
    numChan = 40;
    fRange = [100, 7943.28];  % according to 1/3 octave
    fs_ref = 16000;
    if fs ~= fs_ref
        h_cut = resample(h_cut, fs_ref, fs);
    end
    % gammatone
    [h_gamma, st_gt] = gammatone(h_cut,numChan,fRange,fs_ref);
    elr_sb = zeros(1,size(h_gamma,1));
    rt_sb = zeros(1,size(h_gamma,1));
    for gg = 1:1:size(h_gamma,1)
        grp_delay = st_gt.gd(gg);
        h_sb = h_gamma(gg, grp_delay+1:end);
        [elr_sb(gg), h_sb_cut] = c50_calc( h_sb, fs_ref );
        rt_sb(gg) = t60_ir_nonlinfit(h_sb_cut, fs_ref, 0);
    end
    % [fullband, subband]
    rt = [rt rt_sb];
    elr = [elr elr_sb];
end


end