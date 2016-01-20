% example outputting text


% open a text file
subid = 'sub01';
f1 = fopen( [subid, '.txt'], 'w');

% put the header line
fprintf(f1, 'subid\ttrial\tRT\tacc\tcorrectAns\tuserAns\n')

for trial = 1:10
    % put a string in there
    
    RT = .4;
    acc = 1;   
    subid = 'sub01';
    correctAns = 'abc';
    userAns = 'def';
    
    % HERE DEFINE RESULT STRING
    resultLine = sprintf( '%s\t%d\t%f\t%f\t%s\t%s\n',subid, trial, RT, acc, correctAns, userAns ); 
    % %s for string
    % %d, integer
    % %f, float
    
    % Here save to the text file
    fprintf(f1, resultLine);

end

% close the file
fclose(file);