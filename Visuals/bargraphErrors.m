%avg error per strike (from param in the IV file)
y = [1.72E-02	1.09E-02	1.02E-02	7.96E-03	4.48E-03	3.31E-03	2.47E-03	3.38E-03	4.29E-03	5.06E-03	5.84E-03	6.67E-03	6.80E-03	6.30E-03	6.00E-03	6.17E-03	6.83E-03	8.65E-03	1.04E-02	9.42E-03	8.80E-03	9.15E-03	7.20E-03	8.65E-03	4.80E-03	4.67E-03	4.15E-03	5.87E-03	4.66E-03	6.40E-03	6.51E-03	1.28E-02	7.71E-03
];
x=K';
bar(x,y,'w')
ylim([0 0.025])