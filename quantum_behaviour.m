function P = quantum_behaviour(rho, M)
% function to construct the behaviour generated by implementing
% measurements M on the quantum states rho

% inputs:
% rho(d, d, s) : s d-dimensional quantum states
% M(d, d, o, m) : m o-outcome quantum measurements

d = size(rho,1);
if d ~= size(M,1)
    fprintf('Inconsistent dimensionalities\n')
end
s = size(rho, 3);
o = size(M, 3);
m = size(M, 4);

P = zeros(o, s, m);
for b = 1:o
    for x = 1:s
        for y = 1:m
            P(b, x, y) = trace(rho(:, :, x)*M(:, :, b, y));
        end
    end
end
