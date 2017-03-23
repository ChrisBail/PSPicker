
function [M,ind_ext,ext2,y]=follow_extrem(f,type,num,smooth_vec,option,sense)
    % FOLLOW_EXTREM find extremas using several smoothed versions of a function
    %
    % Steps:
    %   1) locate the 'n' first extremas of the smoothest function
    %   2) refine these points step by step through less and less smooth functions
    %
    % Usage:
    %   M,ind_ext,ext2]=follow_extrem(f,type,num,smooth_vec,option,sense)
    %
    % Inputs:
    %   f, array of interest (unsmoothed)
    %   type:  'mini' or 'maxi', depending on wheter you want to follow minima
    %           or maxima
    %	num:    number of extrema to follow
    %	smooth_vec: vector containing the different smoothings to apply
    %   option: 'normalize': normalize (what?)
    %           anything else: don't normalize
    %	sense:	'first': selects the 'num' first extrema, starting from the right
    %           anything else: select the 'num' biggest extrema
    % Outputs:  value_ext, extrema of unsmoothed function
    %           ind_ext, indices of extrema
    % Exemple:  [value_ext,ind_ext]=follow_extrema(f,'mini',2,[1 5 10]
    
    % Parameters
    if isempty(f), error('f is empty!'); end
    
    smooth_vec=smooth_vec(:);
    m=length(f);
    n=length(smooth_vec);
    smooth_vec=sort(smooth_vec,'descend');
    
    % Construction of smoothed matrix
    
    M=zeros(m,n);
    Mg=cell(n,1);   % cell containing extrema
    
    for i=1:length(smooth_vec)
        clear v v_smooth
        v_smooth=smooth_filtfilt(f,smooth_vec(i));
        line=f_segment(v_smooth);          % Calculation of the straight line
        v_smooth=v_smooth-line;
        v_smooth=cum2grad(v_smooth,option);
        Ext_indices=loca_ext(1,length(v_smooth),v_smooth,type);
        Mg(i)={Ext_indices(:,1)};
        M(:,i)=v_smooth;
    end
    
    % Choose up to 'num' extrema in the smoothest array
    
    ind_sm=Mg{1};
    ord_sm=M(Mg{1},1);
    L=[ind_sm abs(ord_sm)];
    if strcmp(sense,'first')
        A=L;
        A(A(:,2)<0.1,:)=[];
        if isempty(A)
            b=1;
        else
            A=sortrows(A,-1);
            b=A(1,1);
            B=A(2:end,:);
            if ~isempty(B)
                B=sortrows(B,-2);
                try
                    c=B(1:num-1,1);
                catch
                    c=B(1:end,1);
                end
                b=[b;c];
            end
        end
    else
        L=sortrows(L,-2);    % Sort depending the smallest minima or biggest maxima
        try
            b=L(1:num,1);
        catch
            b=L(1:end,1);
        end
    end
    if isempty(b)
        ind_ext=[];
        ext2=[];
        y=[];
        return
    end
    
    ind_ext2(:,1)=b;
    
    ext2(:,1)=M(b,1);
    
    % Following the extremas
    
    y=zeros(length(b),n);
    y(:,1)=M(b,1);
    
    for k=2:n  % Step through smoothings, from 2nd smoothest to not smoothed
        if ~isempty(Mg{k})   % Only update extrema if there are some!!!
            for j=1:length(b)
                clear differ ind_differ
                differ=abs(b(j)-Mg{k});
                if differ>40    % Difference is too big, keep old value
                    c(j)=b(j);
                    continue
                end
                [~,ind_differ]=min(differ);
                c(j)=Mg{k}(ind_differ(1));
            end
            b=c;
        else
            warning('No extrema found for %d-sample smoothing of Kurtosis',smooth_vec(n));
        end
        y(:,k)=M(b,k);
    end
    
    ind_ext(:,1)=b;
    value_ext(:,1)=M(ind_ext,1);
   
    
    %%% Compute standat deviation
    
    disper=zeros(size(ind_ext));
    if ~isempty(ind_ext);
        for j=1:length(ind_ext)
            disper(j)=disper_kurto(M);
        end
    end
    
end

