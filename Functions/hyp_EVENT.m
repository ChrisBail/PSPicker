function OUT=hyp_EVENT(IN,hyp)

%%% Check if phase not empty

% ind_sel=isempty_PHASE(IN.PHASES);
% 
% if isequal(ind_sel,[1:numel(IN.PHASES)])
%     fprintf(1,'PHASES is empty');
%     return    
% end

%%% Write event

for i=1:numel(IN)
    filename=sprintf('hyp_EVENT_%06d.sfile',i);
    event2nor(IN(i),filename)
end

%%% Concatenate files

cmd=['cat hyp_EVENT_*.sfile > input.sfile'];
system(cmd);

%%% Invert

cmd=[hyp,' input.sfile'];
[~,~]=system(cmd);

%%% Read event

OUT=nor2event('hyp.out');

%%% Remove file

cmd='rm hyp_EVENT_*.sfile';
[~,~]=system(cmd);


end