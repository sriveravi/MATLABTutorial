% Samuel Rivera
% MATLAB tutorial, file things

% depending on how your data is stored, you can use a variety of functions
%  to read your file from a .txt file and organize it


%-------------------
%  The following was used for Tobii data, see the doc of those 
%  functions, or the 'gazefileToCell' function for some more tips


%load the data file, each cell for a row
allDataCell = importdata(filename, ' ');

%initialize things
row = regexp(allDataCell{1},'\t','split');
numRows = length( allDataCell );    
numCols = length( row);
data = cell( numRows, numCols);  % cell is a data structure type, see doc

%put in matrix
data(1,:) = row(keepColumns);    
for i1 = 2:numRows    
    row = regexp(allDataCell{i1},'\t','split');
    data(i1,:) = row(keepColumns);    
end  


% NOTE: sometimes the data is loaded as a 'string', but you need it to
%  be a double.  You can use the function: str2double to do this
%  conversion.  Looking at 'workspace' can be very useful for making sure
%  data types are what you want

%-----------

% There are alternative functions for reading files into matlab, see:

% see also 'fileread' for another reading option