function dcsRDM = doubleConditionsSetRDM(patterns_a, patterns_b, varargin)

% dcsRDM = doubleConditionsSetRDM(patterns_a, patterns_b[, distanceMeasure])
%
% patterns_a and patterns_b are both conditions x voxels matrices
%
% distanceMeasure is 'correlation' by default, but can be:
%     'euclidean', ...
%     'seuclidean', ...
%     'cityblock', ...
%     'mahalanobis', ...
%     'minkowski', ...
%     'cosine', ...
%     'correlation', ...
%     'spearman', ...
%     'hamming', ...
%     'jaccard', ...
%     'chebychev'
%
% dcsRDM is a double-conditions-set RDM

%% Catch errors and setup defaults
if ~isequal(size(patterns_b), size(patterns_a))
    error('Split data inputs matrices must be of the same size.');
end%if
if numel(varargin) == 0
    distanceMeasure = 'correlation';
elseif numel(varargin) == 1 && ischar(varargin{1})
    distanceMeasure = varargin{1};
    
    switch distanceMeasure
        case { ...
                'euclidean', ...
                'seuclidean', ...
                'cityblock', ...
                'mahalanobis', ...
                'minkowski', ...
                'cosine', ...
                'correlation', ...
                'spearman', ...
                'hamming', ...
                'jaccard', ...
                'chebychev' ...
                }
        otherwise
            error('Third argument must be a valid distance measure.')
    end
else
    error('Wrong number of arguments (please use 2 or 3).');
end

%% Compute the dcsRDM

% Double the conditions set
patterns_ab = [patterns_a; patterns_b];

% compute the dcsRDM
dcsRDM = squareform(pdist(patterns_ab, distanceMeasure));