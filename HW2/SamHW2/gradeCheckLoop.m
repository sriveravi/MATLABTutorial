

% theyPassed = checkGrades( 1000);
% perc = percPassed( theyPassed );
perc = 0;

ctr = 0;
while perc < .7 % while less than 70& passed
    ctr = ctr+1;
    
    theyPassed = checkGrades( 1000);
    perc = percPassed( theyPassed );
    
    if ctr >= 100
        break;
    end
end

