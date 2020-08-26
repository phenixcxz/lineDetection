%im：输入边缘图像     minlength：输入最小长度
%通过寻找边缘中的三叉交点和端点跟踪边缘，并将每一个连续的边缘存入edgelist中，edgeim存入边缘标号图像
function [edgelist,edgeim] = edgelink(im, minlength, location)
    
    global EDGEIM;      % Some global variables to avoid passing (and
                        % copying) of arguments, this improves speed.
    global ROWS;
    global COLS;
    global RJ;
    global CJ;
    
    EDGEIM = im ~= 0;                     % make sure image is binary.
    EDGEIM = bwmorph(EDGEIM,'clean');     % Remove isolated pixels
    EDGEIM = bwmorph(EDGEIM,'skel',Inf);  % and make sure edges are thinned. I
    edgelist={};                                      % think using 'skel' is better than 'thin'    
    
    % Find endings and junctions in edge data
    [RJ, CJ, re, ce] = findendsjunctions(EDGEIM,1);   %----findendsjunctions函数----

    EDGEIM = double(EDGEIM);   % Convert to double to allow the use of -ve labelings
    [ROWS, COLS] = size(EDGEIM);
    edgeNo = 0;
        
    % Perform raster scan through image looking for edge points.  When a
    % point is found trackedge is called to find the rest of the edge
    % points.  As it finds the points the edge image pixels are labeled
    % with the -ve of their edge No
    
    for r = 1:ROWS
        for c = 1:COLS
            if EDGEIM(r,c) == 1
                edgepoints = trackedge(r,c, edgeNo);
                if ~isempty(edgepoints)
                    edgeNo = edgeNo + 1;                    
                    edgelist{edgeNo} = edgepoints;
                end
            end
        end
    end
    
    edgeim = -EDGEIM;  % Finally negate image to make edge encodings +ve.

    
    % Eliminate isolated edges and spurs that are below the minimum length

%     if nargin >= 2 && ~isempty(minlength)
%         edgelist = cleanedgelist(edgelist, minlength);
%     
%     else  % Call cleanedgelist with 0 minlength anyway to fix spurrious nodes
%           % that may exist due to problem with EDGELINK at points where
%           % junctions are adjacent.
%         edgelist = cleanedgelist(edgelist, 0);
%     end
%    
%     
%     % If subpixel edge locations are supplied upgrade the integer precision
%     % edgelists that were constructed with data from 'location'.
%     if nargin == 3
%         for I = 1:length(edgelist)
%             ind = sub2ind(size(im),edgelist{I}(:,1),edgelist{I}(:,2));
%             edgelist{I}(:,1) = real(location(ind))';
%             edgelist{I}(:,2) = imag(location(ind))';    
%         end
%     end
    
    
%----------------------------------------------------------------------    
% TRACKEDGE
%
% Function to track all the edge points associated with a start point.  From a
% given starting point it tracks in one direction, storing the coords of the
% edge points in an array and labelling the pixels in the edge image with the
% -ve of their edge number. This continues until no more connected points are
% found, or a junction point is encountered.  At this point the function returns
% to the start point and tracks in the opposite direction.
%
% Usage:   edgepoints = trackedge(rstart, cstart, edgeNo)
% 
% Arguments:   rstart, cstart   - row and column No of starting point
%              edgeNo           - the current edge number
%              minlength        - minimum length of edge to accept
%
% Returns:     edgepoints       - Nx2 array of row and col values for
%                                 each edge point.

function edgepoints = trackedge(rstart, cstart, edgeNo)
    
    global EDGEIM;
    global RJ;
    global CJ;
    global noPoint;
    global thereIsAPoint;
    global lastPoint;    

    noPoint = 0;
    thereIsAPoint = 1;
    lastPoint = 2;
    
    edgepoints = [rstart cstart];      % Start a new list for this edge.
    EDGEIM(rstart,cstart) = -edgeNo-1;   % Edge points in the image are %2011年2月8日更改，原来没有-1
                                       % encoded by -ve of their edgeNo.
    
    [status, r, c] = nextpoint(rstart,cstart, edgeNo); % Find next connected
                                                       % edge point.

    while status ~= noPoint
        edgepoints = [edgepoints             % Add point to point list
                       r    c   ];
        EDGEIM(r,c) = -edgeNo-1;               % Update edge image%2011年2月8日更改，原来没有-1

        if status == lastPoint               % We have hit a junction point
            status = noPoint;                % make sure we stop tracking here
        else
            [status, r, c] = nextpoint(r,c, edgeNo); % Otherwise keep going
        end
    end

    % Now track from original point in the opposite direction - but only if
    % the starting point was not a junction point
    
    if ~isjunction(rstart,cstart)        
        % First reverse order of existing points in the edge list
        edgepoints = flipud(edgepoints);  
        
        % ...and start adding points in the other direction.
        [status, r, c] = nextpoint(rstart,cstart, edgeNo); 
        
        while status ~= noPoint
            edgepoints = [edgepoints
                          r    c   ];
            EDGEIM(r,c) = -edgeNo-1; %2011年2月8日更改，原来没有-1
            if status == lastPoint
                status = noPoint;
            else
                [status, r, c] = nextpoint(r,c, edgeNo);
            end
        end
    end
    
    % Final check to see if this edgelist should have start and end points
    % matched to form a loop.  If the number of points in the list is four or
    % more (the minimum number that could form a loop), and the endpoints are
    % within a pixel of each other, append a copy if the first point to the
    % end to complete the loop
    
    if length(edgepoints) >= 4
        if abs(edgepoints(1,1) - edgepoints(end,1)) <= 1  &&  ...
           abs(edgepoints(1,2) - edgepoints(end,2)) <= 1 
            edgepoints = [edgepoints
                          edgepoints(1,:)];
        end
    end
    
    
    
%----------------------------------------------------------------------    
%
% NEXTPOINT
%
% Function finds a point that is 8 connected to an existing edge point
%

function [status, nextr, nextc] = nextpoint(rp,cp, edgeNo)

    global EDGEIM;
    global ROWS;
    global COLS;
    global RJ;
    global CJ;
    global noPoint;
    global thereIsAPoint;
    global lastPoint;        
    
    % row and column offsets for the eight neighbours of a point
    roff = [-1  0  1  0 -1 -1  1  1];
    coff = [ 0  1  0 -1 -1  1  1 -1];

    r = rp+roff;
    c = cp+coff;
    
    % Find indices of arrays of r and c that are within the image bounds
    ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));
    
    % Search through neighbours and see if one is a junction point
    for i = ind 
        if (any(c(i) == CJ(RJ==r(i)))) && (EDGEIM(r(i),c(i)) ~= -edgeNo) 
            % This is a junction point that we have not marked as part of
            % this edgelist
            nextr = r(i);
            nextc = c(i);
            status = lastPoint;
            return;             % break out and return with the data
        end
    end
    
    % If we get here there were no junction points.  Search through neighbours
    % and return first connected edge point that itself has less than two
    % neighbours connected back to our current edge.  This prevents occasional
    % erroneous doubling back onto the wrong segment

    checkFlag = 0;
    for i = ind
        if EDGEIM(r(i),c(i)) == 1
            n = neighbours(r(i),c(i));
            if sum(n==-edgeNo) < 2
                nextr = r(i);
                nextc = c(i);
                status = thereIsAPoint;
                return;             % break out and return with the data
            
            else                    % Remember this point just in case we
                checkFlag = 1;      % have to use it
                rememberr = r(i);
                rememberc = c(i);               
            end
            
        end
    end
    
    % If we get here (and 'checkFlag' is true) there was no connected edge point
    % that had less than two connections to our current edge, but there was one
    % with more.  Use the point we remembered above.
    if checkFlag      
        nextr = rememberr;
        nextc = rememberc;
        status = thereIsAPoint;       
        return;                % Break out
    end
        
    % If we get here there was no connecting next point at all.
    nextr = 0;   
    nextc = 0;
    status = noPoint;

    
%------------------------------------------------------------------------
% Function to test whether a location in the image is a junction point.
% Note that for speed this code has been hard wired into NEXTPOINT.

function b = isjunction(r,c)
    global RJ;
    global CJ;
    
    b = any(c == CJ(RJ==r));
    
%------------------------------------------------------------------------
% Function to get the values of the 8 neighbouring pixels surrounding a point
% of interest.  The values are ordered from the top-left point going
% anti-clockwise around the pixel.
function n = neighbours(rp, cp)
    
    global EDGEIM;
    global ROWS;
    global COLS;

    % row and column offsets for the eight neighbours of a point
    roff = [-1  0  1  1  1  0 -1 -1];
    coff = [-1 -1 -1  0  1  1  1  0];
    
    r = rp+roff;
    c = cp+coff;
    
    % Find indices of arrays of r and c that are within the image bounds
    ind = find((r>=1 & r<=ROWS) & (c>=1 & c<=COLS));    

    n = zeros(1,8);
    for i = ind
        n(i) = EDGEIM(r(i),c(i));    
    end
    