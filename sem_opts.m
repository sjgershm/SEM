function opts = sem_opts(opts)
    
    % Set default options.
    %
    % USAGE: opts = sem_opts([opts])
    %
    % INPUTS:
    %   opts - structure with any of the following fields (missing or empty fields will
    %   be set to defaults):
    %           .K - maximum number of event types (default: 20)
    %           .lambda - stickiness (default: 10)
    %           .alpha - concentration parameter (default: 0.1)
    %           .beta - transition noise variance (default: 0.1)
    %           .eta - learning rate (default: 0.01)
    %           .f - transition function handle (default: @f_lin)
    %
    % OUTPUTS:
    %   opts - completed options structure
    %
    % Sam Gershman, Sep 2016
    
    def_opts.K = 20;
    def_opts.lambda = 10;
    def_opts.alpha = 0.1;
    def_opts.beta = 0.2;
    def_opts.eta = 0.01;
    def_opts.tau = 0.1;
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