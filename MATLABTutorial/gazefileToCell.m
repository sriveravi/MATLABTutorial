%
% Samuel Rivera,  with some code borrowed from David's program
% Date: June 20, 2011
% Notes: This function loads the gazeData into a cell for use by matlab
% 
% syntax:  data = gazefileToCell( filename, keepColumns, makeDoubleColumns)
% 
% inputs: 
%   filename: string of .gazedata file
%   keepColumns: vector indexing columns to keep.  omit or make [] to
%       keep all.  Usually 'keepColumns = [ 1:30 ];'
%   makeDoubleColumns: vector indexing columns to convert from string
%       to double format. Usually 'makeDoubleColumns = [1:24];
% 
% output:
%   data: a matlab cell containing all the data
% 

function data = gazefileToCell( filename, keepColumns, makeDoubleColumns )
    % filename = '../Test_Data/Adult_Supervised_Sparse/Learners/CostOfAttention_Sparse_Supervision_AC-034-1.gazedata';
     
    %load the data file, each cell for a row
    allDataCell = importdata(filename, ' ');

    %initialize things
    row = regexp(allDataCell{1},'\t','split');
    numRows = length( allDataCell );    
    if nargin < 2 || isempty(keepColumns)
         numCols = length( row);
         keepColumns = 1:numCols;
    else
        numCols = length( keepColumns );
    end
    data = cell( numRows, numCols);

    %put in matrix
    data(1,:) = row(keepColumns);    
    for i1 = 2:numRows    
        row = regexp(allDataCell{i1},'\t','split');
        data(i1,:) = row(keepColumns);    
    end   
    
    % convert necessary ones double (from string)    
    if nargin >= 3 && ~isempty( makeDoubleColumns )
        data(2:end,makeDoubleColumns)  = cellfun( @(x) str2double(x), ...
            data(2:end,makeDoubleColumns) , 'UniformOutput', false); 
    end
    
end