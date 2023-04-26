function [x, w] = GenerateExpSinh(n)
% Generate abscissas (x) and weights (w) for Exp Sinh integration
% Using Newton-Cotes methods in transformed integral
% ideal for integrating from 0 to inf
%   n = number of abscissas
%   ta = end points for integration in transformed interval 
%       typically (~4-4.25)

%pre-allocate 
tk = zeros(n,1);
x = zeros(n,1);
w = zeros(n,1);

%equal width of abscissas in transformed function
h = 2*ta/n

%still WIP

