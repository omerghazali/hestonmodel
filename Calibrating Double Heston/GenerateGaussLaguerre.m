function [x, w] = GenerateGaussLaguerre(n)

i = 1:n;
a = (2*i-1);
b = sqrt( i(1:n-1) .* (1:n-1) );
CM = diag(a) + diag(b,1) + diag(b,-1);

[V, L] = eig(CM);
[x, ind] = sort(diag(L));
V = V(:,ind)';
w0 = gamma(1).* V(:,1).^2;
w=w0.*exp(x);
