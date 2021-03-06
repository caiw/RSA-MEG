function MDSRDMs(varargin)

% MDSRDMs({RDMs, [RDMs2, ...]}, userOptions, localOptions)
%
% Will draw MDS plots of RDMs.
%
%        RDMs, RDMs2, ... --- Structs of RDMs.
%                All RDMs in here will be placed on an MDS plot.
%
%        userOptions --- The options struct.
%                userOptions.analysisName
%                        A string which is prepended to the saved files.
%                userOptions.rootPath
%                        A string describing the root path where files will be
%                        saved (inside created directories).
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
%                userOptions.criterion
%                        The criterion which will be minimised to optimise the
%                        MDS arrangement. Defaults to metric stress.
%                userOptions.rubberbands
%                        Boolean value. If true, rubberbands indicating MDS
%                        distortion are drawn on the MDS plot. Defaults to true.
%
%        localOptions --- Further options.
%                localOptions.titleString
%                        If set, this will replace the default title for the
%                        dendrogram.
%                localOptions.name
%                localOptions.figureNumber
%                        If specified, this will set the figure number of the
%                        produced figure. Otherwise the figure number will be
%                        randomly generated (and probably large).
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

RDMs = concatenateRDMs(RDMCell{:});

nRDMs = numel(RDMs);

if nRDMs < 3
	warning('MDSRDMs:NotEnoughRDMs', ['Only ' num2str(nRDMs) ' RDMs is not enough. 3 is a minimum for MDS to work; skipping.']);
	return;
end%if:nRDMs<3

%% Set defaults and check options struct
if ~isfield(userOptions, 'analysisName'), error('MDSRDMs:NoAnalysisName', 'analysisName must be set. See help'); end%if
if ~isfield(userOptions, 'rootPath'), error('MDSRDMs:NoRootPath', 'rootPath must be set. See help'); end%if
userOptions = setIfUnset(userOptions, 'saveFigurePDF', false);
userOptions = setIfUnset(userOptions, 'saveFigurePS', false);
userOptions = setIfUnset(userOptions, 'saveFigureFig', false);
userOptions = setIfUnset(userOptions, 'displayFigures', true);
userOptions = setIfUnset(userOptions, 'criterion', 'metricstress');
userOptions = setIfUnset(userOptions, 'rubberbands', true);

if ~isfield(localOptions, 'name'), localOptions.name = ''; end%if

% Some preferences

if nRDMs < 3
	warning('MDSRDMs:FewerThanThreeRDMs', 'Can''t perform MDS on fewer than three points, skipping.');
	return;
else
	
	MDSOptions.MDSCriterion = userOptions.criterion;
	MDSOptions.rubberbandGraphPlot = userOptions.rubberbands;
	
	% Work out names
	RDMs = orderfields(RDMs, {'RDM', 'color', 'name'});
	RDMCell = struct2cell(RDMs);
	RDMNames = RDMCell(3,1,:);
	MDSOptions.textLabels = RDMNames;
	
	% Work out dot colours
	if isfield(localOptions, 'dotColours')
		MDSOptions.dotColours = localOptions.dotColours;
	else
		MDSOptions.dotColours = [];
		for i = 1:nRDMs
			MDSOptions.dotColours = [MDSOptions.dotColours; RDMs(i).color];
		end%for:i
	end%if:localOptions.dotColours
	
	% Figure numbers
	if isfield(localOptions, 'figureNumber')
		figureNumber = localOptions.figureNumber;
	else
		figureNumber = 1000000*floor(100*rand);
	end%if
	MDSOptions.figI_textLabels = [figureNumber 1 2 1];
	MDSOptions.figI_shepardPlots = [figureNumber 1 2 2];
	
	MDSOptions.fileName = ['SecondOrderMDS_' localOptions.name];
	
    if ~exist(fullfile(userOptions.rootPath, 'Figures'),'dir')
        mkdir(fullfile(userOptions.rootPath, 'Figures'));
    end
	cd(fullfile(userOptions.rootPath, 'Figures'));
	
	distanceMatrix.RDM = 1 - RDMCorrMat(RDMs);
	distanceMatrix.name = 'Pairwise RDM correlations.';

	if isfield(localOptions, 'titleString')
		MDSOptions.titleString = localOptions.titleString;
	else
		MDSOptions.titleString = 'Second-order comparison MDS';
	end%if:localOptions.titleString
	
	fprintf(['Drawing MDS arrangement for RDMs...\n        "' MDSOptions.titleString '" [figure ' num2str(figureNumber) ']\n']);

	figureMDSArrangement(distanceMatrix, userOptions, MDSOptions);

	cd(returnHere);
	
end%if:nRDMs<3
