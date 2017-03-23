% Function made to detect first local extrema
% b=loca_ext(1,length(a),a,'maxi');

function A=loca_ext(first_ind,ind_right,f,type)

y4 = diff(sign(diff(f)));
y4 = same_inc(y4,first_ind,ind_right);


if strcmp(type,'maxi')
    max_loc = [0;y4 < 0;0];
    Fmax = find(max_loc == 1);
    indice=Fmax;
else 
    min_loc = [0;y4 > 0;0];
    Fmin = find(min_loc == 1);
    indice=Fmin;
end

value=f(indice);
A=[indice value];


end

