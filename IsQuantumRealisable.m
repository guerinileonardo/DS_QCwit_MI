function [vis, M, lambda, alpha] = IsQuantumRealisible(P, rho)
% function to check whether the behaviour (P, rho) from the
% semi-quantum prepare and measure scenario admits a quantum realisation

% input: 
% P(o,s,m): behaviour of o outcomes associated to s quantum states
%           and m classical labels
% rho(d,d,s): s d-dimensional states associated to the behaviour

d = size(rho,1);
o = size(P,1);
s = size(P,2);
m = size(P,3);
if size(rho,3) ~= s
    fprintf('Inconsistent dimensionalities\n')
end

cvx_begin sdp quiet
    variable M(d,d,o,m) complex % measurements that generate the behaviour 
    variable q(o,s,m) % noise-probabilities
    variable vis(1,1) nonnegative % visibility parameter (if below 1, then 
                                  % the behaviour is not quantum)
    dual variables lambda{o,s,m} % coefficients of the dual inequality
    dual variables A{m} % provide the bound for the dual inequality
    maximise vis
    for y = 1:m
        for x = 1:s
            for b = 1:o
                % this constraint already ensures the subnormalisation
                % sum(q(:,x,y)) = 1-vis
lambda{b,x,y} : vis*P(b,x,y) + q(b,x,y) == trace(M(:,:,b,y)*rho(:,:,x));
            end
        end
    end
    % M are valid measurements
    for y = 1:m
        for b = 1:o
            M(:,:,b,y) >= 0;
        end
 A{y} : sum(M(:,:,:,y),3) == eye(2);
    end
    % q are subnormalised probabilities
    for y = 1:m
        for x = 1:s
            for b = 1:o
                q(b,x,y) >= 0;
            end
        end
    end
cvx_end

alpha = 0;
for y = 1:m
    alpha = alpha + trace(A{y});
end

% the associated post-quantum witness is 
% sum_{bxy}lambda_{bxy}P(b|rho_x,y) >= alpha
