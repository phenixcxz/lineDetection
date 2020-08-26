%Ñ°ÕÒÍ¼ÏñµÄ¶Ëµã
function [re, ce,num] = findendspoint(edgeim, disp)

    if nargin == 1
	disp = 0;
    end
    % Ensure edge/line image really is thinnned otherwise tests for junctions
    % and endings may fail.
    EDGEIM = edgeim ~= 0;                     % make sure image is binary.
    EDGEIM = bwmorph(EDGEIM,'clean');     % Remove isolated pixels
    b = bwmorph(EDGEIM,'skel',Inf);  % and make sure edges are thinned. I
                                          % think using 'skel' is better than 'thin'     
    edgeim = double(edgeim);   % Convert to double to allow the use of -ve labelings

    % Set up a look up table to find endings.  
    lut = makelut(@ending, 3);
    ends = applylut(b, lut);
    [re,ce] = find(ends);    
    num=length(re);
    
    if disp    
	    imshow(edgeim,1), hold on
	    plot(ce,re,'g+')    
    end
    
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
    