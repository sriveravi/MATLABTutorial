function theyPassed = checkGrades( numGrades)

if nargin < 1  % if no inputs to function, use this default value
    numGrades = 1000;
end

grades = rand( 1,numGrades);

theyPassed = zeros( 1, length(grades));
for idx =1:length(grades)
    theyPassed( idx ) = studentPassed( grades(idx));
end
