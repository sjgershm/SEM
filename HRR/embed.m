function X = embed(N,D,distr,param)
    
    % Embed symbols in a vector space.
    %
    % USAGE: X = embed(N,D,distr,param)
    %
    % INPUTS:
    %   N - number of symbols
    %   D - number of dimensions
    %   distr - string specifying the distribution on the vector space:
    %           'spikeslab_gaussian' - mixture of Gaussian "slab" and Bernoulli "spike"
    %           'spikeslab_uniform' - mixture of uniform "slab" and Bernoulli "spike"
    %
    %   param (optional) - parameters of the distribution:
    %                      'spikeslab_gaussian' - param = [variance, spike probability] (default: [1 1])
    %                      'spikeslab_uniform' - param = [bound around 0, spike probability] (default: [1 1])
    % OUTPUTS;
    %   X - [N x D] matrix
    %
    % Sam Gershman, Jan 2013
    
    switch distr
        
        case 'spikeslab_gaussian'
            if nargin < 3; param = [1 1]; end
            spike = round(double(rand(N,D)<param(2)));
            slab = randn(N,D)*param(1);
            X = spike.*slab;
            
        case 'spikeslab_uniform'
            if nargin < 3; param = [1 1]; end
            spike = round(double(rand(N,D)<param(2)));
            slab = unifrnd(-param(1),param(1),N,D);
            X = spike.*slab;
    end