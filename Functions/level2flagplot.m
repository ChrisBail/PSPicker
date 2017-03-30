function flag_plot=level2flagplot(len_flags,level)
% function made to get flagplot array from level of verbosity
% Input: len_flags > size array of flag_plot
%             level > level of verbosity (0=no verbosity, 4 high verbosity)
% Output: flag_plot: array containing verbosity boolean
% 
% Example: flag_plot=level2flagplot(3,1) , then flag_plot=[1 0 0]

flag_plot=zeros(len_flags,1);

if level>len_flags
    level=len_flags;
end

flag_plot(1:level)=1;

end