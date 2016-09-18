function D = plate_formula(N,K,err)
    
    % Determine the number of dimensions needed according to Plate's (2003)
    % formula:
    %   D = 3.16(K-0.25)ln(N/err^3)
    % where D is the number of dimensions, K is the maximum number of terms
    % to be combined, N is the number of atomic values in the langauge, and
    % err is the probability of error.
    %
    % USAGE: D = plate_formula(N,K,err)
    %
    % Sam Gershman, Jan 2013
    
    D = round(3.16*(K-0.25)*(log(N)-3*log(err)));