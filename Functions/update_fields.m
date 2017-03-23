% Developer function
% 
% This function is made to update the fields of a structure, in case
% some fields were not set in prior processes, for example wyou worked with
% refine_Picks in earlier version and then afterwards you decide to define a 
% new field, instead of reprocessing the data you can just update fields to
% missing field. 
% NB: it will NOT remove fields in USER structure, just add
% 
% Input:
%     STRUCT_USER: user structure
%     STRUCT_REF: reference structure
%     
% Output:
%     STRUCT_NEW: new structure with fields updated

function STRUCT_NEW=update_fields(STRUCT_USER,STRUCT_REF)

%%% Get fields

field_ref=fieldnames(STRUCT_REF);

%%% Compare fields

field_user=fieldnames(STRUCT_USER(1));
field_missing=field_ref(~ismember(field_ref,field_user));
for j=1:numel(STRUCT_USER)
for i=1:numel(field_missing)
    STRUCT_USER(j).(field_missing{i})=STRUCT_REF.(field_missing{i});
end
end

STRUCT_NEW=STRUCT_USER;

end