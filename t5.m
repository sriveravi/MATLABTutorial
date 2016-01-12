% Samuel Rivera
% 
%  In this exercise, implement a binary search algorithm to find the root
%   of some function.  You will learn about passing functions to functions
%   by using funtion handles with anonymous functions, as well as some
%   plotting tricks.
% 
%   references: http://www.mathworks.com/help/matlab/ref/function_handle.html
% handle = @functionname
% handle = @(arglist)anonymous_function

%-------------------------------
% here define the function and plot it and the zero 

contFun = @(x) x.^2-.5;  % a function handle to x^2 -.5

x = linspace( 0,1,100);
plot( x, contFun(x))
hold on
plot( x, zeros( [1,length(x)]), 'g-', 'linewidth', 3)



% now find the root, and plot it.  Feel free to make the plot nice
range = [0,1];
precision = .001;
 x0 = findRoot( contFun, range, precision);
 
 
 
 % additional exercises, 
%  problems 2 and from here:
%  http://www.facstaff.bucknell.edu/maneval/help211/progexercises.html
 