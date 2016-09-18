function SEM = sem_init(opts)
    
    % Initialize SEM structure.
    %
    % USAGE: SEM = sem_init([opts])
    %
    % INPUTS:
    %   opts - options structure (see sem_opts.m)
    %
    % OUTPUTS:
    %   SEM - structure with the following fields:
    %           .C - [1 x K] event type counts
    %           .k - event inferred on the previous trial (initialized to empty)
    %           .theta - [K x M] parameters for each event type
    %
    % Sam Gershman, Sep 2016
    
    if nargin < 1; opts = []; end
    opts = sem_opts(opts);  % fill in missing fields
    
    SEM.C = zeros(1,opts.K);
    SEM.k = [];
    for k = 1:opts.K
        SEM.theta(k,:) = opts.f(opts.D);
    end