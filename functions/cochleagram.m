function a = cochleagram(r, winLength, sCf)
% Generate a cochleagram from responses of a Gammatone filterbank.
% It gives the log energy of T-F units
% The first variable is required.
% winLength: window (frame) length in samples
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2
    winLength = 320;      % default window length in sample points which is 20 ms for 16 KHz sampling frequency
end
    
if nargin < 3
    sCf = 2;      % default window length in sample points which is 20 ms for 16 KHz sampling frequency
end


[numChan,sigLength] = size(r);     % number of channels and input signal length

winShift = winLength/sCf;            % frame shift (default is half frame)
M = 1 + floor((sigLength-winLength)/winShift);

% calculate energy for each frame in each channel
a = zeros(numChan,M);
for m = 1:M      
    for i = 1:numChan        
        startpoint = (m-1)*winShift;
        a(i,m) = real(r(i,startpoint+1:startpoint+winLength)*r(i,startpoint+1:startpoint+winLength)');
    end
end

