function hz=erb2hz(erb)
% Convert ERB-rate scale to normal frequency scale.
% Units are number of ERBs and number of Hz.
% ERB stands for Equivalent Rectangular Bandwidth.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hz=(10.^(erb/21.4)-1)/4.37e-3;

