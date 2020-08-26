function [mag,e] = GetImageMag(a)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Transform to a double precision intensity image if necessary
if ~isa(a,'double') && ~isa(a,'single') 
  a = im2single(a);
end
thresh=[];
sigma=2;
[m,n] = size(a);

% The output edge map:
e = false(m,n);
  GaussianDieOff = .0001;  
  PercentOfPixelsNotEdges = .7; % Used for selecting thresholds
  ThresholdRatio = .4;          % Low thresh is this fraction of the high.
  
  % Design the filters - a gaussian and its derivative
  
  pw = 1:30; % possible widths
  ssq = sigma^2;
  width = find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff,1,'last');
  if isempty(width)
    width = 1;  % the user entered a really small sigma
  end

  t = (-width:width);
  gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq);     % the gaussian 1D filter

  % Find the directional derivative of 2D Gaussian (along X-axis)
  % Since the result is symmetric along X, we can get the derivative along
  % Y-axis simply by transposing the result for X direction.
  [x,y]=meshgrid(-width:width,-width:width);
  dgau2D=-x.*exp(-(x.*x+y.*y)/(2*ssq))/(pi*ssq);
  
  % Convolve the filters with the image in each direction
  % The canny edge detector first requires convolution with
  % 2D gaussian, and then with the derivitave of a gaussian.
  % Since gaussian filter is separable, for smoothing, we can use 
  % two 1D convolutions in order to achieve the effect of convolving
  % with 2D Gaussian.  We convolve along rows and then columns.

  %smooth the image out
  aSmooth=imfilter(a,gau,'conv','replicate');   % run the filter across rows
  aSmooth=imfilter(aSmooth,gau','conv','replicate'); % and then across columns
  
  %apply directional derivatives
  ax = imfilter(aSmooth, dgau2D, 'conv','replicate');
  ay = imfilter(aSmooth, dgau2D', 'conv','replicate');

  mag = sqrt((ax.*ax) + (ay.*ay));
  magmax = max(mag(:));
  if magmax>0
    mag = mag / magmax;   % normalize
  end
  figure
  imshow(mag);
   % Select the thresholds
  if isempty(thresh) 
    counts=imhist(mag, 64);
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,...
                      1,'first') / 64;
    lowThresh = ThresholdRatio*highThresh;
    thresh = [lowThresh highThresh];
  elseif length(thresh)==1
    highThresh = thresh;
    if thresh>=1
      eid = sprintf('Images:%s:thresholdMustBeLessThanOne', mfilename);
      msg = 'The threshold must be less than 1.'; 
      error(eid,'%s',msg);
    end
    lowThresh = ThresholdRatio*thresh;
    thresh = [lowThresh highThresh];
  elseif length(thresh)==2
    lowThresh = thresh(1);
    highThresh = thresh(2);
    if (lowThresh >= highThresh) || (highThresh >= 1)
      eid = sprintf('Images:%s:thresholdOutOfRange', mfilename);
      msg = 'Thresh must be [low high], where low < high < 1.'; 
      error(eid,'%s',msg);
    end
  end
  
  % The next step is to do the non-maximum suppression.  
  % We will accrue indices which specify ON pixels in strong edgemap
  % The array e will become the weak edge map.
  idxStrong = [];  
  for dir = 1:4
    idxLocalMax = cannyFindLocalMaxima(dir,ax,ay,mag);
    idxWeak = idxLocalMax(mag(idxLocalMax) > lowThresh);
    e(idxWeak)=1;
    idxStrong = [idxStrong; idxWeak(mag(idxWeak) > highThresh)];
  end
  figure
  imshow(e);
  
end

