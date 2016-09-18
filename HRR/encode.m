function c = encode(a,b)
    
    % Encoding using circular convolution.
    %
    % USAGE: c = encode(a,b)
    %
    % INPUTS:
    %   a,b - row vectors of the same length
    %
    % OUTPUTS:
    %   c - row vector of the same length as a and b
    %
    % Sam Gershman, Jan 2013
    
    c = cconv(a,b,length(a));