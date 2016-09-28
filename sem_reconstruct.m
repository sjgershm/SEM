function [x2r, x2p] = sem_reconstruct(x1,x2,e1,opts,SEM)
    
    % Reconstruct memory from noisy traces.
    %
    % USAGE: [x2r, x2p] = sem_reconstruct(x1,x2,e1,[opts],[SEM])
    
    if nargin < 4; opts = []; end
    opts = sem_opts(opts);  % fill in missing fields
    D = size(x1,2);
    opts.D = D;
    if nargin < 5 || isempty(SEM); SEM = sem_init(opts); end
    
    u = (1/opts.beta)/((1/opts.beta) + (1/opts.tau));   % weighting factor
    x2p = opts.f(x1,SEM.theta(e1,:));                   % predicted event
    x2r = u*x2p + (1-u)*x2;                             % reconstructed event