function est_mxt = calculate_nnet3_compute( feat, mdl, kaldi_path )
% calcuate the auditory-inspired features
%
% Input:
%   feat:       input features (dim x frames)
%   mdl:        kaldi nnet3 model (.raw)
%
%
% Output:
%   est_mxt:    estimated matrix (dim x frames)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% store feature into .scp .ark
CopyfeatBin = [kaldi_path '/featbin/copy-feats'];
featark = 'tmp_feat.ark';
featscp = [featark(1:end-3) 'scp'];
tmptxt  = [featark(1:end-3) 'txt'];
fid = fopen(tmptxt,'w');
fprintf(fid,'%s  [\n ', 'tmp');
nfram2=size(feat,2);
for t=1:nfram2
    fprintf(fid,' %.7g', feat(:,t));
    fprintf(fid,' \n ');
end
fprintf(fid,' ]\n');
fclose(fid);
[~,~]=system([CopyfeatBin ' --compress=true ark,t:' tmptxt ' ark,scp:' featark ',' featscp]);
system(['rm ' tmptxt]);

% nnet3-compute
Nnet3Compute = [kaldi_path '/nnet3bin/nnet3-compute'];
tmptxt  = 'mdl_output.txt';
[~,~]=system([Nnet3Compute ' --use-gpu=no --apply-exp=true ' mdl ' scp:' featscp ' ark,t:' tmptxt]);

% read output .txt
fid=fopen(tmptxt,'r');
tmpdata=fscanf(fid,'%c');
fclose(fid);
b = strfind(tmpdata,'[');
e = [-1 strfind(tmpdata,']')];
%uttnam=tmpdata(e(1)+2:b(1)-3);
est_mxt = eval(tmpdata(b(1):e(1+1))).';   % dim x frames

% delete tmp.*
system(['rm ' tmptxt ' ' featark ' ' featscp]);

% figure, imagesc(est_mxt)

end