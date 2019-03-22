# SQPaM

Code to accompany the article **[Final title](www.arxiv.org/abs/1903.XXXXX)**, by Leonardo Guerini, Marco Túlio Quintino, and Leandro Aolita.

All code is written in MATLAB and requires [CVX](http://cvxr.com/) - a Matlab-based convex modeling framework.

The [main](https://github.com/guerinileonardo/SQPaM/blob/master/main.m) script of this repository calculates the examples presented in Appendices A, B, and E of the paper, making use of the auxiliary functions: 
* [IsQuantumRealisable](https://github.com/guerinileonardo/SQPaM/blob/master/IsQuantumRealisable.m): decides whether a given behaviour is quantum realisable and provides unphysical witnesses; 
* [IsDSwCC](https://github.com/guerinileonardo/SQPaM/blob/master/IsDSwCC.m): decides whether a given quantum realisable behaviour is distributedly samplable with classical communication and provides quantum communication witnesses;
* [quantum_behaviour](https://github.com/guerinileonardo/SQPaM/blob/master/quantum_behaviour.m): constructs the quantum behaviour generated a set of measurements implemented on a set of states
* [Pauli_matrices](https://github.com/guerinileonardo/SQPaM/blob/master/Pauli_matrices.m): constructs the Pauli matrices.

The [witness_study](https://github.com/guerinileonardo/SQPaM/blob/master/witness_study.m) script constructs a quantum communication witness and an ensemble of quantum states, such that the (incompatible) measurements that provide a violation of the former present an advantage in the discrimination of the latter when compared to compatible measurements.
