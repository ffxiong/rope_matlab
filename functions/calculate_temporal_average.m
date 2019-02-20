function val_est = calculate_temporal_average( mlp_posteriors, val_name, avg_mode, window_len )
% temporal averaging based on the neural network output
%
% Input:
%   mlp_posteriors:     MLP output posteriors (dim x frames)
%   val_name:           'rt' or 'elr'
%   avg_mode:           'utterance': utterance-based mode, 'window':
%                       temporal window based with window_len
%   window_len:         window length since the first frame
%
%
% Output:
%   val_est:            estimated room parameter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

window_len = 170;   % if subband, then 300 frames!
if nargin < 4
    window_len = 1; % without subband results
    avg_mode = 'utterance';
end
if nargin < 3
    avg_mode = 'utterance';
end

if strcmp( avg_mode, 'utterance' )
    mean_val = mean( mlp_posteriors, 2 );
end

if strcmp( avg_mode, 'frame' )
    frame_total = min( window_len, size(mlp_posteriors,2) );
    mean_val = mean( mlp_posteriors(:, 1:frame_total), 2 );
end


% winner-take-all
[~, ind_max] = max(mean_val);
ind_max = ind_max(1);   % only take one value if equal prob.

% label
%lab_dim = size(mlp_posteriors, 1);
if strcmp(val_name, 'rt')
    rt_start = 200;
    rt_res = 100; % resolution
    val_est = rt_start + rt_res * (ind_max-1);
end
if strcmp(val_name, 'elr')
    elr_start = 25;
    elr_res = 1; % resolution
    val_est = elr_start - elr_res * (ind_max-1);
end


end