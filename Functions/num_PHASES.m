% function to know number of phases

function num_pha=num_PHASES(PHASES,type)


A={PHASES(:).ARRIVAL}';
ind_arr=cellfun(@(x) ~isempty(x),A);

B={PHASES(:).WEIGHT}';
ind_weight=cellfun(@(x) ~isempty(x) && x<4,B);

C={PHASES(:).TYPE}';
ind_type=cellfun(@(x) ~isempty(x) && x==type,C);

ind_select=ind_arr & ind_weight & ind_type;

num_pha=sum(ind_select);

end