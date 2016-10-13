function [x2r, x2p] = sem_reconstruct(x1,x2,e1,opts,SEM)
    
    % Reconstruct memory from noisy traces.
    %
    % USAGE: [x2r, x2p] = sem_reconstruct(x1,x2,e1,[opts],[SEM])
    %
    % INPUTS:
    %   x1 - encoded scene vector at time 1
    %   x2 - encoded scene vector at time 2
    %   e1 - event assignment for time 1
    %   opts (optional) - options structure
    %   SEM (optional) - structured event memory object
    %
    % OUTPUTS:
    %   x2r - reconstructed scene vector at time 2
    %   x2p - predicted scene vector at time 2 under event e1
    %
    % Sam Gershman, Oct 2016
    
    if nargin < 4; opts = []; end
    opts = sem_opts(opts);  % fill in missing fields
    D = size(x1,2);
    opts.D = D;
    if nargin < 5 || isempty(SEM); SEM = sem_init(opts); end
    
    u = (1/opts.beta)/((1/opts.beta) + (1/opts.tau));   % weighting factor
    x2p = opts.f(x1,SEM.theta(e1,:));                   % predicted event
    x2r = u*x2p + (1-u)*x2;                             % reconstructed event