% Samuel Rivera
% MATLAB tutorial, Matrix things


%MAT-lab stands for matrix lab, and is great for doing linear algebra and
%     operations on matrices and vectors


% y is a row vector
y = [ 4 5 6]
z = [ 1; 2;3 ]  % columns

% you can take the transpose by
y = y'  % be careful, if complex it does the complex conjugate


% you can initialize a matrix like this
x = [ 1 2 3; 4 5 6; 7 8 9]


% matlab has convenient functions to make special matrices
% a function is a defined procedure or routine.  Some take arguments, and
%  some return values


oneMat = ones( 4, 7)  % the function 'ones' returns a matrix of 
                                % ones with specified parameters
                                % (arguments)
                                
                                
% learn about a function by typing 'help functionName'
%                                             or  'doc funcitonName'


zeroMat = zeros(  5, 3)  % notice the first argument is
                                % the number of rows, and the second the 
                               % number of columns
        
orderList = 1:10
evenList = 2:2:10
                               
                               
% the (row, column) index is standard in matlab.  So
% if you want to access the '6' in 'x',that would be
x(2,3)

%  notice that the top left entry of matrix corresponds to
%  position ( 1,1).  Unlike other programming languages
%  where the top left is (0,0), MATLAB indexes starting with 1


%---------
%  There are other convenient methods for working with matrices

% if you want to make a matrix into a vector

xVec = x(:)

% notice what happened, it stacks the COLUMNS of x into one vector

% and if we want to get it back?
xShape = size( x) % the original dimensions of x

xVec = reshape( x, xShape)
xVecAlt = reshape( x, [3,3])
xVecAlt2 = reshape( x, 3, [] )


% you can also duplicate a matrix
xRep = repmat( x, 1, 3)  % you guessed it, the '1' tells how many times
        % to repeat vertically, and the 3 how many times horizontally
        
        
% sometimes you have data points that need to be put into a big matrix
x1 = [ 1 1 1 1 1]
x2 = [ 0 0 0 0 0]

X = [x1; x2;x1;x2] % the semicolon means put it in the row underneath

XTrans = [ x1(:) x2(:) x1(:) x2(:) ] % or we can stack horizontalls without semicolon

X' - XTrans

% are they equal?
isEqual = (X' == XTrans) 
notEqual = (X' ~= XTrans) % in workspace you can see type 'logical' (bool)
greatEqual = ( X' >= XTrans )
greater = ( X' > XTrans )


%----------------------


% when we have matrices, we can do mathematicl operations.  Typically 
%   a '.' in front the operator means do element-wise 

oneMat = ones( 5)
2.*oneMat 
oneMat + 5  % when its a scalar, it usually defaults to element wise



% matrix operations are understood without the '.'
identMat = eye( 5)  % identity
y = rand( 5,1)

%           (5x5 mat) *(5 x 1 vect)  , dimensions have to agree
prodYIdent = identMat*y




% matlab has many procedures you  can call that are built in
help elfun

