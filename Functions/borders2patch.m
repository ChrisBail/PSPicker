function [x_patch,y_patch]=borders2patch(x,y)

%%% Check that x and y are of size 2

if numel(x)~=2 && numel(y)~=2
   fprintf(1,'Coordinates given are not of size 2');
   return;
end

%%% Sort coordinates

x=sort(x);
y=sort(y);

%%% Create patch

x_patch=[x(1) x(2) x(2) x(1)];
y_patch=[y(1) y(1) y(2) y(2)];

end

