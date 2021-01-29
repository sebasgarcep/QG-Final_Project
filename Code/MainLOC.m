L = load('SampleLorenz');

N = 20;
Ne = randperm(1000,N);

XB = L.XB(:,Ne);

PB = cov(XB');

figure;
surf(PB)

n = 40;
r = 2
L = localization_matrix(n,r);

figure;
surf(L)

PL = L.*PB;

figure;
surf(PL)