function pairwiseCorrelateRDMs(varargin)

% parwiseCorrelateRDMs({RDMs, [RDMs2, ...,]}, userOptions[, localOptions])
%
% Will draw a second-order similarity matrix from RDMs.
%
%        RDMs, RDMs2, ... --- Structs of RDMs.
%                All RDMs in here will be concatenated and pairwise correlated
%                to create a large second-order similarity matrix.
%
%        userOptions --- The options struct.
%                userOptions.analysisName
%                        A string which is prepended to the saved files.
%                userOptions.rootPath
%                        A string describing the root path where files will be
%                        saved (inside created directories).
%                userOptions.distanceMeasure
%                        A string descriptive of the distance measure to be used
%                        to compare two RDMs. Defaults to 'Spearman'.
%                userOptions.saveFigurePDF
%                        A boolean value. If true, the figure is saved as a PDF.
%                        Defaults to false.
%                userOptions.saveFigurePS
%                        A boolean value. If true, the figure is saved as a PS.
%                        Defaults to false.
%                userOptions.saveFigureFig
%                        A boolean value. If true, the figure is saved as a
%                        MATLAB .fig file. Defaults to false.
%                userOptions.displayFigures
%                        A boolean value. If true, the figure remains open after
%                        it is created. Defaults to true.
%                userOptions.colourScheme
%                        A colour scheme for the RDMs. Defualts to jet(64).
%
%        localOptions --- Further options.
%                localOptions.fileName
%                localOptions.fileName
%                        Whatever is in this string will replace the '%' in the
%                        saved fileName 'analysisName_%secondOrderSM[.pdf]'
%                        under which figures may be saved. Defaults to empty.
%                localOptions.figureNumber
%                        If specified, this will set the figure number of the
%                        produced figure. Otherwise the figure number will be
%                        randomly generated (and probably large).
%
% May save figures according to preferences.
%
% Cai Wingfield 5-2010

returnHere = pwd;

RDMCell = varargin{1};
userOptions = varargin{2};
if nargin == 3
	localOptions = varargin{3};
else
	localOptions = struct();
end%if:nargin

%% Set defaults and check options struct
if ~isfield(userOptions, 'analysisName'), error('pairwiseCorrelateRDMs:NoAnalysisName', 'analysisName must be set. See help'); end%if
if ~isfield(userOptions, 'rootPath'), error('pairwiseCorrelateRDMs:NoRootPath', 'rootPath must be set. See help'); end%if
userOptions = setIfUnset(userOptions, 'distanceMeasure', 'Spearman');
userOptions = setIfUnset(userOptions, 'saveFigurePDF', false);
userOptions = setIfUnset(userOptions, 'saveFigurePS', false);
userOptions = setIfUnset(userOptions, 'saveFigureFig', false);
userOptions = setIfUnset(userOptions, 'displayFigures', true);
localOptions = setIfUnset(localOptions, 'fileName', '');
localOptions = setIfUnset(localOptions, 'figureNumber', 1000000*floor(100*rand));

% Concatenate RDMs
nRDMStructs = numel(RDMCell);
RDMs = concatenateRDMs(RDMCell{:});
nRDMs = numel(RDMs);

corrMat = RDMCorrMat(RDMs, localOptions.figureNumber, userOptions.distanceMeasure);

if isfield(userOptions, 'colourScheme')
	set(gcf,'Colormap', userOptions.colourScheme);
end%if

thisFileName = [userOptions.analysisName '_' localOptions.fileName 'secondOrderSM'];

handleCurrentFigure(fullfile(userOptions.rootPath, 'Figures',thisFileName), userOptions);

fprintf(['Saving second-order similarity matrix to ' fullfile(userOptions.rootPath, 'Statistics', thisFileName) '\n']);
gotoDir(userOptions.rootPath, 'Statistics');
save([thisFileName '.mat'], 'corrMat');

gotoDir(fullfile(userOptions.rootPath, 'Scripts'));
cd(returnHere);
