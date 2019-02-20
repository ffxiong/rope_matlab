function feat_out = calculate_mvn( feat_in, cmvn_file )
% temporal averaging based on the neural network output
%
% Input:
%   feat_in:            input feature (dim x frames)
%   cmvn_file:          cmvn options from model folder
%
%
% Output:
%   feat_out:           output feature (with / without normalization)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2
    flag_mean = 0;
    flag_var = 0;
else
    fid = fopen(cmvn_file);
    cmvn_info = textscan(fid, '%s', 'delimiter', '\n');
    fclose(fid);
    cmvn_info = cmvn_info{1};
    cmvn_info = cmvn_info{1};
    ind_mean = strfind( cmvn_info, '--norm-means=' );
    flag_mean = 0;
    if ~isempty(ind_mean)
        if strcmp( cmvn_info(ind_mean+13), 't' )
            flag_mean = 1;
        end
    end
    ind_var = strfind( cmvn_info, '--norm-vars=' );
    flag_var = 0;
    if ~isempty(ind_mean)
        if strcmp( cmvn_info(ind_var+12), 't' )
            flag_var = 1;
        end
    end
end

% no normalization
feat_out = feat_in;

% only mean normalization
if flag_mean && ~flag_var
    mxt_mean = repmat( mean(feat_in,2), 1, size(feat_in,2));
    feat_out = feat_in - mxt_mean;
end

% only variance normalization
if flag_var && ~flag_mean
    mxt_std = repmat( std(feat_in, 0, 2), 1, size(feat_in,2) );
    feat_out = feat_in ./ mxt_std;
end


if flag_mean && flag_var
    mxt_mean = repmat( mean(feat_in,2), 1, size(feat_in,2));
    mxt_std = repmat( std(feat_in, 0, 2), 1, size(feat_in,2) );
    feat_out = (feat_in - mxt_mean) ./ mxt_std;
end


end