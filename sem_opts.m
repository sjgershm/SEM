function opts = sem_opts(opts)
    
    % Set default options.
    %
    % USAGE: opts = sem_opts([opts])
    %
    % INPUTS:
    %   opts - structure with any of the following fields (missing or empty fields will
    %   be set to defaults):
    %           .K - maximum number of event types (default: 20)
    %           .lambda - stickiness (default: 0.1)
    %           .alpha - concentration parameter (default: 1)
    %           .beta - transition noise variance (default: 1)
    %           .eta - learning rate (default: 0.1)
    %           .f - transition function handle (default: @f_lin)
    %
    % OUTPUTS:
    %   opts - completed options structure
    %
    % Sam Gershman, Sep 2016
    
    def_opts.K = 20;
    def_opts.lambda = 10;
    def_opts.alpha = 0.1;
    def_opts.beta = 0.1;
    def_opts.eta = 0.9;
    def_opts.f = @f_lin;
    
    if nargin < 1 || isempty(opts)
        opts = def_opts;
    else
        F = fieldnames(def_opts);
        for j = 1:length(F)
            if ~isfield(opts,F{j})
                opts.(F{j}) = def_opts.(F{j});
            end
        end
    end