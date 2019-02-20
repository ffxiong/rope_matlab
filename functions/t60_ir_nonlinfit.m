function [t60, extras] = t60_ir_nonlinfit(ir, fs, flg_plt)
%T60_IR_NONLINFIT T60 esitmation using nonlinear optimisation to fit model to 
%impulse response  
%
% [t60, extras] = t60_ir_nonlinfit(ir, fs)
%
% inputs:
%            ir   impulse response [Nx1 vector]
%            fs   sample rate in Hertz
%
% outputs:
%           t60   reverberation time in seconds (assuming fs was passed in)
%        extras   structure containing additional outputs
%                     extras.sig    signal level [dB]
%                   extras.noise    noise level [dB]
%                     extras.snr    signal to noise ratio [dB]
%
%Uses code developed by M. Karjalainen
% http://www.acoustics.hut.fi/software/decay/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[t60, extras.sig, extras.noise ] = fit_decay_model(ir, fs, flg_plt);
extras.snr = extras.sig-extras.noise;