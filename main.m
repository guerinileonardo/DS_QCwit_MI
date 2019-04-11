% script to investigate the main ideias in the paper arxiv:XXXXX regarding
% semi-quantum prepare-and-measure scenario, quantum realisable behaviours,
% distributed sampling with classical communication, post-quantum
% witnesses, and quantum communication witnesses

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% starters

d = 2; % dimension of the systems

% defining the Pauli matrices sigmaX, sigmaY, sigmaZ
Pauli_matrices;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we start by defining a behaviour (P, rho) from the semi-quantum
% prepare-and-measure scenario and checking its quantum realisation
% (Appendix A)

% scenario
s1 = 3; % number of states rho_x
m1 = 1; % number of measurements M_y
o1 = 2; % number of outcomes b


% states rho_x
rho1 = zeros(d,d,s1);
rho1(:,:,1) = (eye(2) + sigmaZ)/2;
rho1(:,:,2) = (eye(2) - sigmaZ)/2;
rho1(:,:,3) = eye(2)/2;

% behaviour P(b|rho_x, y)
P1 = zeros(o1,s1,m1);
P1(2,1,1) = 1;
P1(2,2,1) = 1;
P1(1,3,1) = 1;

% checking whether this behaviour admits a quantum realisation
[vis1, ~, lambda, alpha] = IsQuantumRealisable(P1, rho1);

% the obtained visibility vis1 should match the optimal value for the dual
% 1 + sum_{b,x,y}lambda(b,x,y)*P1(b,x,y) - alpha
temp1 = lambda.*P1;
temp1 = sum(temp1(:));
dual_optval1 = 1 + temp1 - alpha;
Duality_check1 = (abs(vis1 - dual_optval1) <= 10e-08); % must be 1

% the violation of sum_{b,x,y}lambda(b,x,y)*P1(b,x,y) >= alpha indicates that
% P1 is a post-quantum behaviour
QR_witness_violation = (temp1 < alpha); % must be 1

% if temp1 < alpha
%     fprintf('P2 violates the unphysical witness (lambda,alpha)\n')
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we now define a second behaviour, quantum realisable by definition, 
% defined in Appendix B

s2 = 4;
m2 = 2;
o2 = 2;

% states
rho2 = zeros(d,d,s2);
rho2(:,:,1) = (eye(2) + sigmaX)/2;
rho2(:,:,2) = (eye(2) + sigmaY)/2;
rho2(:,:,3) = (eye(2) + sigmaZ)/2;
rho2(:,:,4) = (eye(2))/2;

% measurements
M2 = zeros(d,d,o2,m2);
M2(:,:,1,1) = (eye(2) + sigmaX)/2;
M2(:,:,2,1) = (eye(2) - sigmaX)/2;
M2(:,:,1,2) = (eye(2) + sigmaY)/2;
M2(:,:,2,2) = (eye(2) - sigmaY)/2;

% behaviour
P2 = quantum_behaviour(rho2, M2);

% safety check
visQR = IsQuantumRealisable(P2, rho2);
Quantum_Realisation_check = (abs(visQR - 1) <= 10e-08); % must be 1

% verifying that behaviour2 does not a distributed sampling realisation
% with classical communication 
[visCC, ~, mu, beta] = IsCCRealisable(P2, rho2, M2, 1);
% visCC is the visibility that makes P2 CC-realisable when the noise is 
% fixed to be maximally random (white noise)

% the obtained visibility visCC should match the optimal value for the dual
% 1 + sum_{b,x,y}mu(b,x,y)*P(b,x,y) - beta
temp2 = mu.*P2;
temp2 = sum(temp2(:));
dual_optval2 = 1 + temp2 - beta;
Duality_check2 = (abs(visCC - dual_optval2) <= 10e-08); % must be 1

% the violation of sum_{b,x,y}mu(b,x,y)*P2(b,x,y) >= beta indicates that
% P2 demands quantum communication for its preparation
QC_witness_violation = (temp2 < beta); % should be 1

% this instance provides the quantum communication witness (mu, beta)
% described in Appendix B

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finally, we now provide the calculations for the distributed sampling
% with classical communication of some behaviours; equivalently, this
% provides the incompatibility robustness of the given set of measurements
% restricted to specific sets of states (Appendix E)

% fixing the set of measurements
m = 3;
o = 2;
Msigmas = zeros(d,d,o,m);
Msigmas(:,:,1,1) = (eye(2) + sigmaX)/2;
Msigmas(:,:,2,1) = (eye(2) - sigmaX)/2;
Msigmas(:,:,1,2) = (eye(2) + sigmaY)/2;
Msigmas(:,:,2,2) = (eye(2) - sigmaY)/2;
Msigmas(:,:,1,3) = (eye(2) + sigmaZ)/2;
Msigmas(:,:,2,3) = (eye(2) - sigmaZ)/2;

% defining the first set of states
ss1 = 2;
S1 = zeros(d,d,ss1);
S1(:,:,1) = (eye(2) + sigmaX)/2;
S1(:,:,2) = (eye(2) + sigmaZ)/2;

behav1 = quantum_behaviour(S1, Msigmas);

% the white-noise robustness of Msigmas restricted to S1 is found to be
% t1 = 0.9449
t1 = IsCCRealisable(behav1, S1, Msigmas, 1);

% defining the second set of states
ss2 = 3;
S2 = zeros(d,d,ss2);
S2(:,:,1) = (eye(2) + sigmaX)/2;
S2(:,:,2) = (eye(2) + sigmaZ)/2;
S2(:,:,3) = (eye(2) + sigmaY)/2;

behav2 = quantum_behaviour(S2, Msigmas);

% the white-noise robustness of Msigmas restricted to S2 is found to be
% t2 = 0.8165
t2 = IsCCRealisable(behav2, S2, Msigmas, 1);

% defining the third set of states
ss3 = 4;
S3 = zeros(d,d,ss3);
S3(:,:,1) = (eye(2) + sigmaX)/2;
S3(:,:,2) = (eye(2) + sigmaZ)/2;
S3(:,:,3) = (eye(2) + sigmaY)/2;
S3(:,:,4) = eye(2)/2;

behav3 = quantum_behaviour(S3, Msigmas);

% the white-noise robustness of Msigmas restricted to S3 is found to be
% t3 = 0.5774
t3 = IsCCRealisable(behav3, S3, Msigmas, 1);
