function map=vec2map(vec,mask)

% USAGE
%       map=vec2map(vec,mask)
%
% FUNCTION
%       to convert space column vector vec into a spatial map of dimensions of array
%       mask. mask is a logical array whose true values must correspond to
%       vec in number and order.
%
%       the returned maps are zero, whereever the mask is false.
%
% GENERAL IDEA: In a situation where you have a mask ("mask") defining an RoI
%               (1s inside the RoI, 0s outside) one could use this function to
%               fill the RoI with statistical values from a vector "vec".  The
%               result will be a map "map" with 0s outside the original roi
%               and values taken from vec inside.

mask=logical(mask);
map=zeros(size(mask));
map(mask)=vec;