% Computes a Fisher Transformation on the input vector (honest!)
%
% USAGE:
% 	setOut = fisherTransform(setIn[, fakeIt])
%
% (setting fakeIt to true will replace inf values by 1/eps)
%
% Cai Wingfield 2-2010

function setOut = fisherTransform(setIn, fakeIt)

if ~exist('fakeIt', 'var')
	fakeIt = false;
end%if

setOut = atanh(setIn);

if fakeIt
	for i = 1:numel(setOut)
		if isinf(setOut(i))
			setOut(i) = 1 / eps;
		end%if
	end%for:i
end%if
