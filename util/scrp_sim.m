function e = scrp_sim(N,alpha,lambda)
    
    % Simulate sticky Chinese restaurant process.
    %
    % USAGE: e = scrp_sim(N,alpha,lambda)
    %
    % INPUTS:
    %   N - number of timepoints
    %   alpha - concentration parameter
    %   lambda - stickiness
    %
    % OUTPUTS:
    %   e - [1 x N] event assignments
    %
    % Sam Gershman, Sep 2016
    
    e = [1 zeros(1,N-1)];
    C = e;
    K = 1;
    
    for n = 2:N
        p = C;
        p(K+1) = alpha;
        p(e(n-1)) = p(e(n-1)) + lambda;
        e(n) = fastrandsample(p./sum(p));
        C(e(n)) = C(e(n)) + 1;
        K = max(K,e(n));
    end