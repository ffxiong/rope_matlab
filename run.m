% run script to play ROPE algorithm to estimate reverberation time (RT) and
% early-to-late reverberation ratio (ELR) with direct reveberant speech
% input.
%
% run.m
%
% It is processed in the full frequency band mode and the neural
% network has been trained and transfered in .txt formant from Kaldi
% toolkit.

% Verion 0.1:   01 Feb. 2019 (Kaldi required to be installed)
% 
% If you use this software in a publication, please cite:
%
% F. Xiong, S. Goetze, B. Kollmeier, B. T. Meyer, "Exploring
% Auditory-Inspired Acoustic Features for Room Acoustic Parameter Estimation
% from Monaural Speech", In: IEEE/ACM Transactions on Audio, Speech, and
% Language Processing 26(10), pp. 1809-1820, 2018.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2019 ASAP @ Medi @ Uni. Oldenburg
% This software is distributed under the terms of the GNU Public License
% version 3 (http://www.gnu.org/licenses/gpl.txt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;

%% Global parameters
kaldi_src = '/data/ac1fx/software/sharc/kaldi/src'; % please specify your Kaldi /src path!!!

addpath('functions/');
fs_ref = 16000; % referance sampling frequency


%% Deterimine the Ground Truth of RT and ELR based on room impuluse response (RIR)
% read one RIR 
[h, fs_h] = audioread('audios/rir_example.wav');
if fs_h ~= fs_ref
    h = resample(h, fs_ref, fs_h);
end
h = h(:) / norm(h);

% RT and ELR ground truth
[rt, elr] = calculate_groundtruth( h, fs_ref, 0 );

disp([ '###### The Ground Truth of fullband RT is ' num2str(rt(1)) ' ms ...']);
disp([ '###### The Ground Truth of fullband ELR is ' num2str(elr(1)) ' dB ...']);

%% Speech synthesis to simulate the real-recorded reverberant speech
[s, fs_s] = audioread('audios/clean_speech_example.wav');
if fs_s ~= fs_ref
    s = resample(s, fs_ref, fs_s);
end

% convolution
x = fconv(s, h);
[~, max_h] = max(abs(h));
% cut off: to avoid a very long tail
x = x(max_h:max_h+length(s)-1);
    
% add diffuse noise if you'd like
flag_add_noise = 0;
snr_dB = 18;  % adjust by yourself
noise_name = 'pinknoise_example.wav';
if flag_add_noise
    h_l = h(max_h+round(fs_ref*0.05)+1:end);   % late reverberation model (check the paper)
    h_l = h_l / norm(h_l);
    [n, fs_n] = audioread(['audios/' noise_name]); % pick up one anechoic noise
    if fs_n ~= fs_ref
        n = resample(n, fs_ref, fs_n);
    end
    n_hl = fconv(n, h_l);
    y = v_addnoise(x, fs_ref, snr_dB, '', n_hl, fs_ref);
    disp('###### The reverberant and noisy speech is y ...');
else
    y = x;
    disp('###### The reverberant (no noise) speech is x ...');
end


%% Auditory-inspired feature extraction
auditory_feature = calculate_auditory_feature( y, fs_ref );

% normalization (compatiable to the models)
cmvn_file = 'models/cmvn_opts';
auditory_feature = calculate_mvn( auditory_feature, cmvn_file );

disp('###### The auditory-inspired features are auditory_feature ...');

%% Neural networkd read and forward-pass
rt_mdl = 'models/rt_fullband_mlp.raw';
elr_mdl = 'models/elr_fullband_mlp.raw';

% nnet3-computee
rt_est_mxt = calculate_nnet3_compute( auditory_feature, rt_mdl, kaldi_src );
elr_est_mxt = calculate_nnet3_compute( auditory_feature, elr_mdl, kaldi_src );

disp('###### The estimated matrix are *_est_mxt ...');


%% Temporal averaging and make the final decision
% utterance-based average
rt_est = calculate_temporal_average( rt_est_mxt, 'rt' );
elr_est = calculate_temporal_average( elr_est_mxt, 'elr' );

disp([ '###### The Estimate (ROPE) of fullband RT is ' num2str(rt_est) ' ms ...']);
disp([ '###### The Estimate (ROPE) of fullband ELR is ' num2str(elr_est) ' dB ...']);
