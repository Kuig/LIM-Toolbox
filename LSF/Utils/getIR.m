function [ IR ] = getIR( r, xScale, yScale, mType, aType, centerValue, s, K )
%   DEPRECATED, this function will change syntax in the future
%
%[ IR ] = getIR( r, ___ )
%   Returns a complex kernel of size r-by-r of specified type
%   Typical use: getIR(r,1,1,'gauss','out',0,K);
%   With K = 0.02 for r = 6 or K = 0.005 for r = 12
%
%[ IR ] = getIR( r, xScale, yScale, mType, aType, centerValue )
%   mType: DIST HANN GAUSS RECT DoG
%   aType: IN OUT CW CCW
%       s: mag power
%
%[ IR ] = getIR( r, xScale, yScale, 'DoG', aType, centerValue, s, K )
%   s: sigma of first gaussian
%   K: ratio of second gaussian
%
%[ IR ] = getIR( type )
%   type: SOBEL GRADIENT
%
% Use [] to skip 'centerValue'

    if ~ischar(r)
        if nargin < 3
            xScale = 1;
            yScale = 1;
        end;

        if nargin < 4, mType = 'dist'; end
        if nargin < 5, aType = 'out'; end;

        if nargin < 6, centerValue = []; end;

        if nargin < 7; s = 1.00; end;
        if nargin < 8; K = 1.25; end;
        
        [X,Y] = meshgrid(-r+1:r-1,-r+1:r-1);

        X = X * xScale;
        Y = Y * yScale;

        switch lower(mType)
            case 'dist'
                iIRm = (1./( X.^2 + Y.^2 )).^s;
            case 'hann' % Approximation
                iIRm = (0.5 .* (1-cos(2*pi*(X-r)/(2*r)))...
                     .* 0.5 .* (1-cos(2*pi*(Y-r)/(2*r)))).^s;
            case 'gauss'
                iIRm = (exp(-X.^2-Y.^2)).^s;
            case 'rect'
                iIRm = ones(size(X));
            case 'dog'
                iIRm = ( 1/(2*pi*s.^2) )      .* (exp( -(X.^2+Y.^2)/(2*s.^2)       )) - ...
                       ( 1/(2*pi*s.^2*K.^2) ) .* (exp( -(X.^2+Y.^2)/(2.*K.^2*s.^2) ));
            otherwise
                error ('Unknown magnitude type, use DIST, HANN, GAUSS, RECT or DoG');
        end;

        if ~isempty(centerValue), iIRm(r,r) = centerValue; end;

        switch lower(aType)
            case 'in'
                iIRa = atan2(Y,X)+pi;
            case 'out'
                iIRa = atan2(Y,X);
            case 'cw'
                iIRa = atan2(X,-Y);
            case 'ccw'
                iIRa = atan2(-X,Y);
            otherwise
                error ('Unknown angle type, use IN, OUT, CW, or CCW');
        end;
        
        iIRa(iIRm<0) = iIRa(iIRm<0)+(pi/2);
        IR = iIRm .* exp(1i * iIRa);
    
    else
        switch lower(r)
            case 'sobel'
                IR = [ -1-1i   0-2i   1-1i  ;
                       -2+0i   0+0i   2+0i  ;
                       -1+1i   0+2i   1+1i ];

            case 'gradient'
                IR = [  0.0    0.5i   0.0  ;
                        0.5    0.0   -0.5  ;
                        0.0   -0.5i   0.0 ];
            otherwise
                error ('Unknown mask type, use SOBEL, GRADIENT or other parameters');
        end;
    end;
end

