function gotoDir(varargin)

% gotoDir(path, dir)
%     Goes to path; then goes to dir, making it if necessary.
%
% gotoDir(path)
%     Goes to path, making all required directories on the way.

switch nargin
	case 2
		path = varargin{1};
		dir = varargin{2};

		try
			cd(path)
		catch
			error('gotoDir:NonexistantPath', ['The path "' path '" does not refer!']);
		end%try
		
		try
			cd(dir);
		catch
			fprintf(['The directory "' dir '" doesn''t exist at "' path '"; making it.\n']);
			mkdir(dir);
			cd(dir);
		end%try

	case 1

		path = varargin{1};
		sIndices = strfind(path, filesep);
		
		for i = 1:numel(sIndices)
		
			if i == 1 && sIndices(i) == 1
				continue;
			end%if
			
			try
				cd(path(1:sIndices(i)-1));
			catch
				fprintf(['The directory "' path(1:sIndices(i)-1) '" doesn''t exist... making it.\n']);
				mkdir(path(1:sIndices(i)-1));
                cd(path(1:sIndices(i)-1));
			end%try
		
		end%for:i
        
		% cleanup final directory!
        try
            cd(path);
        catch
			fprintf(['The directory "' path '" doesn''t exist... making it.\n']);
            mkdir(path);
        end%try
		
		cd(path);

otherwise
	error('gotoDir:BadNargin', 'Only 1 or 2 arguments allowed.');
end%switch:nargin