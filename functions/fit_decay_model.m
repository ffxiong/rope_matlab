function [ T60, sig, noise ] = fit_decay_model( ir,fs,fig )
%FIT_DECAY_MODEL estimates the T60, signal amplitude and noise level of an
%impulse response
%
%[ T60, sig, noise ] = fit_decay_model( ir,fs )
%
%Inputs:
%ir:    column vector containing impulse response measurement
%fs:    sampling frequency
%
%Outputs:
%T60:   Estimated reverb time
%sig:   Amplitude of decaying exponential (dB)
%noise: Amplitude of measurement noise (dB)
%
%This function is just a wrapper to decay_fit.m by M. Karjalainen
%see: http://www.acoustics.hut.fi/software/decay/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<3, fig=0, end

sgn = 20*log10(abs(ir+eps));        %convert to db
lgenv = sgn-max(sgn);           %normalise
[val,indx]=max(lgenv);          %find peak

%construct rectangular window which is zero before and one after the peak
w = [zeros(indx-1,1);ones(length(lgenv)-indx+1,1)];
%w = [zeros(indx+round(0.008*fs),1);ones(length(lgenv)-indx-round(0.008*fs),1)];
%w = ones(length(lgenv),1);

%call the fitting function
[coeffs norm]=hut_decay2_fit([lgenv,[1:length(lgenv)]'/fs],[],w,fig);

%convert calculated parameters into useful format
T60 = log(10^(-60/20))/coeffs(2) * 1000;  % ms
sig = 20*log10(abs(coeffs(1)));
noise = 20*log10(abs(coeffs(3)));
%snr_db = sig-noise;
end

