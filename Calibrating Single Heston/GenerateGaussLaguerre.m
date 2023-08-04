function [x, w] = GenerateGaussLaguerreNew(n)
%only good up to n=~32 
i = 1:n;
a = (2*i-1);
b = sqrt( i(1:n-1) .* (1:n-1) );
CM = diag(a) + diag(b,1) + diag(b,-1);

[V, L] = eigs(CM,n);
[x, ind] = sort(diag(L));
X = V(:,ind).';
w0 = X(:,1).^2;
w=w0.*exp(x);

