function c = decode(a,b)
    
    % Decoding using circular cross-correlation. 
    % If c = encode(a,b) then decode(c,b) is approximately equal to a.
    %
    % USAGE: c = decode(a,b)
    %
    % INPUTS:
    %   a,b - row vectors of the same length
    %
    % OUTPUTS:
    %   c - row vector of the same length as a and b
    %
    % Sam Gershman, Jan 2013
    
    c = ifft(fft(a).*conj(fft(b)));
    c = c/length(a);