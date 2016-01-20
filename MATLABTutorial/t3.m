% Samuel Rivera
% MATLAB tutorial, loops 

% sometimes we want a program to repeat a procedure, or do something if
% some condition happens


% use a 'for' loop for specified number of looops
for i1 = 1:5  % what is 1:5?
    display( 'the value of i1 is: ')
    i1
end

% make it look nicer, and just print odd numbers in range (1,20)
for i1 = 1:2:20  % what is 1:5?
    fprintf( 'the value of i1 is: %d\n', i1);
            % '\n' is a newline character, meaning go to next line
            %  '%d' is a placeholder for an integer, and you put that at
                %  the end after a comma
              % you can also show tabs '\t', and print floats (decimals) '%f' 
end


%----------------------------


% what if you want a loop to happen until some criterion
% lets say you want to add up some numbers until their combined sum is 
% greater than 100

count = 0;
i1 = 1;
while (count < 100)  % this will keep repeating while this is true
                               % you must make sure it starts as true
    count = count+ i1;
    i1 = i1+1;
end
fprintf( 'Total is %d at i1 = %d\n', count, i1)

%------------------------------

% we can also use conditional statements
% lets say if i1 from above is even, we want to display
%  'its even!', or for odd 'that's odd...'

if mod( i1,2) == 0  % modulus returns remainder of i1/2
    display( 'it''s even!') % notice the double '' for displaying the '
else
    display( 'that''s odd...')
end
    

% note that for the conditional, you can put a nonzero number
%  and matlab evaluates that as true












