function passed =  studentPassed( grade )

if grade < 0 || grade > 1 % ||  for or statement,
    error( 'Grade out of range, should be in [0,1]' );                      % && and statement
end

if grade >= .7
    passed = 1;
else
    passed = 0;
end

if grade > .95
%     display( 'super whatever');
end