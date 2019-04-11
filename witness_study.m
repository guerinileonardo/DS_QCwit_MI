% following the work Quantum incompatibility witnesses (arxiv:1812.02985),
% we construct the ensembles E_y={sigma_{by}}_b whose discrimination is
% associated to our quantum communication witness (Appendix D)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% starters

d = 2; % dimension of the systems

% defining the Pauli matrices sigmaX, sigmaY, sigmaZ
Pauli_matrices;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generating a quantum communication witness

% set of states
s = 4; % number of states
rho = zeros(d,d,s);
rho(:,:,1) = (eye(2) + sigmaX)/2;
rho(:,:,2) = (eye(2) + sigmaY)/2;
rho(:,:,3) = (eye(2) + sigmaZ)/2;
rho(:,:,4) = eye(2)/2;

% set of measurements
m = 2; % number of measurements
o = 2; % number of outcomes
M = zeros(d,d,m,o);
M(:,:,1,1) = (eye(2) + sigmaX)/2;
M(:,:,2,1) = (eye(2) - sigmaX)/2;
M(:,:,1,2) = (eye(2) + sigmaY)/2;
M(:,:,2,2) = (eye(2) - sigmaY)/2;

% behaviour
P = quantum_behaviour(rho, M);

% generating a quantum communication witness (mu, beta) 
% sum_{byx} mu(b,y,x)*tr(rho(:,:,x)*M(:,:,b,y)) >= beta
[~, ~, mu, beta] = IsDSwCC(P, rho, M, 1);

% we wish to write it in the form \sum_{y,b} tr(F_{b|y}*M_{b|y})
F = zeros(d,d,o,m);
for y = 1:m
    for b = 1:o
        for x = 1:s
            F(:,:,b,y) = F(:,:,b,y) + mu{b,x,y}*rho(:,:,x);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% constructing the ensembles of states that are discriminated by our
% witnesses, according to arxiv:1812.02985

nu = 0;
for y = 1:m
    for b = 1:o
        nu = nu + norm(F(:,:,b,y));
    end
end
theta = 0;
for y = 1:m
    for b = 1:o
        theta = theta + trace(F(:,:,b,y)) + nu*2;
    end
end
q = zeros(o,m);
sigma = zeros(d,d,o,m);
for y = 1:m
    for b = 1:o
        temp = (F(:,:,b,y) + nu*eye(2))/theta;
        q(b,y) = trace(temp); % preparation probabilities
        sigma(:,:,b,y) = temp/trace(temp); % states
    end
end

% the ensembles are given by E_y = (sigma_{b,y}, q_{b,y})
