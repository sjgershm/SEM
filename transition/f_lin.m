function [x, g] = f_lin(X,theta)
    
    % Linear transition function.
    %
    % USAGE: [x, g] = f_lin(X,theta)
    %
    % Sam Gershman, Sep 2016
    
    if nargin == 1
        b = zeros(1,X);
        W = eye(X);
        x = [b W(:)'];
    else
        D = length(X);
        b = theta(1:D);
        W = reshape(theta(D+1:end),D,D);
        x = b + X*W;
        
        if nargout > 1
            dXdb = eye(D);
            dXdW = repmat(repmat(X',1,D),D,1);
            g = [dXdb; dXdW]';
        end
    end