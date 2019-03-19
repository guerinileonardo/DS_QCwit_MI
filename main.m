% script to investigate the main ideias in arxiv:XXXXX regarding
% semi-quantum prepare-and-measure scenario, quantum realisable behaviours,
% distributed sampling with classical communication, post-quantum
% witnesses, and quantum communication witnesses

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% starters

% all of our examples lie in dimension 2
d = 2; % dimension of the systems

% Pauli matrices
sigmaX = [0, 1; 1, 0];
sigmaY = [0, -1i; 1i, 0];
sigmaZ = [1, 0; 0, -1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we start by defining a behaviour (P, rho) from the semi-quantum
% prepare-and-measure scenario and checking its quantum realisation
% (Appendix A of the paper)

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
[vis1, M1, lambda, alpha] = IsQuantumRealisable(P1, rho1);

% the obtained visibility vis1 should match the optimal value for the dual
% 1 + sum_{b,x,y}lambda(b,x,y)*P1(b,x,y) - alpha
temp1 = 0;
for b = 1:o1
    for x = 1:s1
        for y = 1:m1
            temp1 = temp1 + lambda{b,x,y}*P1(b,x,y);
        end
    end
end
dual_optval1 = 1 + temp1 - alpha;
duality_check1 = (abs(vis1-dual_optval1) <= 10e-08); % should be 1

% the violation of sum_{b,x,y}lambda(b,x,y)*P1(b,x,y) >= alpha indicates that
% P1 is a post-quantum behaviour
QR_witness_violation = (temp1 < alpha); % it should be 1

% if temp1 < alpha
%     fprintf('P2 violates the unphysical witness (lambda,alpha)\n')
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we now define a second behaviour, quantum realisable by definition, 
% defined in Appendix B of the paper

s2 = 4;
m2 = 2;
o2 = 2;

% states
rho2 = zeros(d,d,s2);
rho2(:,:,1) = (eye(2)+sigmaX)/2;
rho2(:,:,2) = (eye(2)+sigmaY)/2;
rho2(:,:,3) = (eye(2)+sigmaZ)/2;
rho2(:,:,4) = (eye(2))/2;

% measurements
M2 = zeros(d,d,o2,m2);
M2(:,:,1,1) = (eye(2)+sigmaX)/2;
M2(:,:,2,1) = (eye(2)-sigmaX)/2;
M2(:,:,1,2) = (eye(2)+sigmaY)/2;
M2(:,:,2,2) = (eye(2)-sigmaY)/2;

% behaviour
P2 = zeros(o2,s2,m2);
for b = 1:o2
    for x = 1:s2
        for y = 1:m2
            P2(b,x,y) = trace(rho2(:,:,x)*M2(:,:,b,y));
        end
    end
end

% safety check
visQR = IsQuantumRealisable(P2,rho2);
QuantumRealisation_check2 = (abs(visQR - 1) <= 10e-08); % should be 1

% verifying that behaviour2 is not distributedly samplable with
% classical communication
[visCC, mom, mu, beta] = IsDSwCC(P2, rho2, M2, 1);
% visCC is the visibility that makes P2 distributedly samplable with
% classical communication, when the noise is fixed to be maximally random
% (white noise)

% the obtained visibility visCC should match the optimal value for the dual
% 1 + sum_{b,x,y}mu(b,x,y)*P(b,x,y) - beta
temp2 = 0;
for b = 1:o2
    for x = 1:s2
        for y = 1:m2
            temp2 = temp2 + mu{b,x,y}*P2(b,x,y);
        end
    end
end
dual_optval2 = 1 + temp2 - beta;
duality_check2 = (abs(visCC - dual_optval2) <= 10e-08); % should be 1

% the violation of sum_{b,x,y}mu(b,x,y)*P2(b,x,y) >= beta indicates that
% P2 demands quantum communication for its preparation
ClassComm_check = (temp2 >= beta); % should be 0

% this instance provides the quantum communication witness (mu, beta)
% described in Appendix B

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finally, we now provide the calculations for the distributed sampling
% with classical communication of some behaviours; equivalently, this
% provides the incompatibility robustness of the given set of measurements
% restricted to specific sets of states (see Appendix E)

% fixing the set of measurements
m = 3;
o = 2;
Msigmas = zeros(d,d,o,m);
Msigmas(:,:,1,1) = (eye(2)+sigmaX)/2;
Msigmas(:,:,2,1) = (eye(2)-sigmaX)/2;
Msigmas(:,:,1,2) = (eye(2)+sigmaY)/2;
Msigmas(:,:,2,2) = (eye(2)-sigmaY)/2;
Msigmas(:,:,1,3) = (eye(2)+sigmaZ)/2;
Msigmas(:,:,2,3) = (eye(2)-sigmaZ)/2;

% defining the first set of states
ss1 = 2;
S1 = zeros(d,d,ss1);
S1(:,:,1) = (eye(2)+sigmaX)/2;
S1(:,:,2) = (eye(2)+sigmaZ)/2;

behav1 = zeros(o,ss1,m);
for b = 1:o
    for x = 1:ss1
        for y = 1:m
            behav1(b,x,y) = trace(S1(:,:,x)*Msigmas(:,:,b,y));
        end
    end
end

% the white noise robustness of Msigmas restricted to S1 is found to be
% t1 = 0.9449
t1 = IsDSwCC(behav1, S1, Msigmas, 1);

% defining the second set of states
ss2 = 3;
S2 = zeros(d,d,ss2);
S2(:,:,1) = (eye(2)+sigmaX)/2;
S2(:,:,2) = (eye(2)+sigmaZ)/2;
S2(:,:,3) = (eye(2)+sigmaY)/2;

behav2 = zeros(o,ss2,m);
for b = 1:o
    for x = 1:ss2
        for y = 1:m
            behav2(b,x,y) = trace(S2(:,:,x)*Msigmas(:,:,b,y));
        end
    end
end

% the white noise robustness of Msigmas restricted to S2 is found to be
% t2 = 0.8165
t2 = IsDSwCC(behav2, S2, Msigmas, 1);

% defining the third set of states
ss3 = 4;
S3 = zeros(d,d,ss3);
S3(:,:,1) = (eye(2)+sigmaX)/2;
S3(:,:,2) = (eye(2)+sigmaZ)/2;
S3(:,:,3) = (eye(2)+sigmaY)/2;
S3(:,:,4) = eye(2)/2;

behav3 = zeros(o,ss3,m);
for b = 1:o
    for x = 1:ss3
        for y = 1:m
            behav3(b,x,y) = trace(S3(:,:,x)*Msigmas(:,:,b,y));
        end
    end
end

% the white noise robustness of Msigmas restricted to S3 is found to be
% t3 = 0.5774
t3 = IsDSwCC(behav3, S3, Msigmas, 1);
