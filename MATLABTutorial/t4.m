% Samuel Rivera

% MATLAB tutorial , functions

% in the previous tutorial, you have already used functions to
%  perform tasks that you will probably do many times


x = ones(3,5);

% The function 'ones' takes in the arguments, and returns a matrix having
%   all 1's
% let us write a function that takes in a number, and returns the number
% squared, and we will need to make a new file for that

out = squareIt( 5)


% just make sure that the file defining functon has same name and is in
% the path

%  you can also return several values

[ out1 out2 ] = squareAndQuad( 3 ) 