# SQPaM

Code to accompany the article **[Final title](www.arxiv.org/abs/1903.XXXXX)**, by Leonardo Guerini, Marco Túlio Quintino, and Leandro Aolita.

All code is written in MATLAB and requires [CVX](http://cvxr.com/) - a Matlab-based convex modeling framework.

The [main]() script of this repository calculates all the examples presented in the Appendices of the paper, making use of the auxiliary functions [IsQuantumRealisable](), thats decides whether a given behaviour is quantum realisable and provides unphysical witnesses, and [IsDSwCC](), that decides whether a given quantum realisable behaviour is distributedly samplable with classical communication and provides quantum communication witnesses.
