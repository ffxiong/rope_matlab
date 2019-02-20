function r = gammatone_process(in, st_gt)
% Produce an array of filtered responses from a Gammatone filterbank.
% The first variable is required. 
% numChan: number of filter channels.
% fRange: frequency range.
% fs: sampling frequency.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gammatone filtering using FFTFILT
gt = st_gt.h;
numChan = size(gt, 1);
r = fftfilt(gt',repmat(in,1,numChan))';

