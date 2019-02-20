function feat = calculate_auditory_feature( y, fs )
% calcuate the auditory-inspired features
%
% Input:
%   y:      speech data (single channel)
%   fs:     sampling frequency
%
%
% Output:
%   feat:   feature data (dim x frames)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters
numChan = 40;  % for gammatone
fRange = [100, 7943.28];  % range of freq. domain, 100Hz according to simulated high frequency cutoff freq. 7943.28 according to 1/3 octave fb
frLen = 25e-3*fs;
frShift = 10e-3*fs;
preEmphasis = 0; % or 0.97

% load the temporal mddulation filter bank
load('tempo_conv_mtx_480.mat');
matrix = tempo_conv_mtx_480.matrix;
context_delay = tempo_conv_mtx_480.delay;

% gammatone
st_gt = gammatone_init(numChan, fRange, fs);

% process
if preEmphasis > 0
    y(2:end) = y(2:end) - preEmphasis * y(1:end-1);
    y(1)=(1-preEmphasis).*y(1);
end

y_gamma = gammatone_process(y, st_gt);
y_auditory = log( max(eps, sqrt(cochleagram(y_gamma, frLen, frLen/frShift))) );

% 2-D multiplication for convolution
y_auditory_context = delay(y_auditory, -context_delay:context_delay);
feat = matrix * y_auditory_context;


end

