function [rj, cj, re, ce] = findendsjunctions(edgeim, disp)

    if nargin == 1
	disp = 0;
    end
    
    % Ensure edge/line image really is thinnned otherwise tests for junctions
    % and endings may fail.
    b = bwmorph(edgeim,'skel',Inf);
    
    % Set up look up table to find junctions.  To do this we use the function
    % defined at the end of this file to test that the centre pixel within a 3x3
    % neighbourhood is a junction.
    lut = makelut(@junction, 3);
    junctions = applylut(b, lut);
    [rj,cj] = find(junctions);
    
    % Set up a look up table to find endings.  
    lut = makelut(@ending, 3);
    ends = applylut(b, lut);
    [re,ce] = find(ends);    

    if disp    
	imshow(edgeim,1), hold on
	plot(cj,rj,'r+')
	plot(ce,re,'g+')    
    end

%----------------------------------------------------------------------
% Function to test whether the centre pixel within a 3x3 neighbourhood is a
% junction. The centre pixel must be set and the number of transitions/crossings
% between 0 and 1 as one traverses the perimeter of the 3x3 region must be 6 or
% 8.
%
% Pixels in the 3x3 region are numbered as follows
%
%       1 4 7
%       2 5 8
%       3 6 9

function b = junction(x)
    
    a = [x(1) x(2) x(3) x(6) x(9) x(8) x(7) x(4)];
    b = [x(2) x(3) x(6) x(9) x(8) x(7) x(4) x(1)];    
    crossings = sum(abs(a-b));
    
    b = x(5) && crossings >= 6;
    
%----------------------------------------------------------------------
% Function to test whether the centre pixel within a 3x3 neighbourhood is an
% ending. The centre pixel must be set and the number of transitions/crossings
% between 0 and 1 as one traverses the perimeter of the 3x3 region must be 2.
%
% Pixels in the 3x3 region are numbered as follows
%
%       1 4 7
%       2 5 8
%       3 6 9

function b = ending(x)
    a = [x(1) x(2) x(3) x(6) x(9) x(8) x(7) x(4)];
    b = [x(2) x(3) x(6) x(9) x(8) x(7) x(4) x(1)];    
    crossings = sum(abs(a-b));
    
    b = x(5) && crossings == 2;
    