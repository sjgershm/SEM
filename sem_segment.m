function [post, SEM] = sem_segment(X,opts,SEM)
    
    % Segment states into events.
    %
    % USAGE: [post, SEM] = sem_segment(X,[opts],[SEM])
    %
    % INPUTS:
    %   X - [N x D] state vectors at each time step
    %   opts - options structure (see sem_opts.m)
    %   SEM - event model structure (see sem_init.m)
    %
    % OUTPUTS:
    %   post - [N x Kactive] posterior over events (only for active events)
    %   SEM - updated event model structure
    %
    % Sam Gershman, Sep 2016
    
    % initialization
    [N,D] = size(X);
    if nargin < 2; opts = []; end
    opts = sem_opts(opts);  % fill in missing fields
    opts.D = D;
    if nargin < 3 || isempty(SEM); SEM = sem_init(opts); end
    post = zeros(N,opts.K);
    
    for n = 1:N
        
        % CRP prior
        prior = SEM.C;
        [~,ix] = find(SEM.C==0,1,'first');
        prior(ix) = opts.alpha;
        if ~isempty(SEM.k)
            prior(SEM.k) = prior(SEM.k) + opts.lambda;
        end
        
        % likelihood
        lik = zeros(1,opts.K);
        active = find(prior>0);
        for k = active
            if n == 1
                [x(k,:),g{k}] = opts.f(zeros(1,D),SEM.theta(k,:));
            else
                [x(k,:),g{k}] = opts.f(X(n-1,:),SEM.theta(k,:));
            end
            lik(k) = sum(lognormpdf(X(n,:),x(k,:),opts.beta));
            %if isnan(lik) || isinf(lik); keyboard; end
        end
        
        % posterior
        p = log(prior(active)) + lik(active);
        post(n,active) = exp(p-logsumexp(p,2));
        
        % update SEM parameters
        [~,k] = max(post(n,:));
        SEM.C(k) = SEM.C(k) + 1;
        SEM.k = k;
        if n > 1 % don't update on the first trial, because the initial state has no past
            SEM.theta(k,:) = SEM.theta(k,:) + opts.eta*(X(n,:)-x(k,:))*g{k};
        end
        
    end
    
    % remove unused events
    m = sum(post); post = post(:,m>0);