% Lasso test

close all;
clear;

load('test_lasso_sparse_data.mat');

[m, n] = size(A);

f = LeastSquares(A, b);
g = NormL1(lam);

Lf = eigs(@(x)A'*(A*x), n, 1, 'LM');

opt.tol = 1e-12;
opt.display = 0;
opt.maxit = 1000;

% Solve using DRN

gam = 0.95/Lf;
out = drn(f, g, zeros(n, 1), gam, opt);
x_drn = out.z;

assert(norm(x_drn - x_star)/(1+norm(x_star)) <= 1e-8);

% Solve using NADMM

rho = 1/gam;
out_nadmm = nadmm(f, g, 1, -1, 0, zeros(n, 1), rho, opt);
x_nadmm = out_nadmm.z;

assert(norm(x_nadmm - x_star)/(1+norm(x_star)) <= 1e-8);
