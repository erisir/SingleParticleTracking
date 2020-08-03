syms D
sigma=10.2;%S/m
thickness=15.0;
d=2.2;
pi = 3.14;
A = pi*D.^2/(4*thickness+pi*D);
B = pi*(D-2).^2/(4*thickness+pi*D-2*pi);

eqn =sigma*(((pi*(D.^2))./(4*thickness)+(pi*D))-((pi*((D-d).^2))./(4*thickness)+(pi*(D-d))))-2==0;
eqn1 = sigma*(A-B)-2 ==0;
eqn;
eqn1;
solx = solve(eqn, D)
solx1 = solve(eqn1, D)

D =  5291539321^(1/2)/3611 - 2843/157
A = pi*D.^2/(4*thickness+pi*D);
B = pi*(D-2).^2/(4*thickness+pi*D-2*pi);
Y1 = sigma*(((pi*(D.^2))./(4*thickness)+(pi*D))-((pi*((D-d).^2))./(4*thickness)+(pi*(D-d))))-2
Y2 =  sigma*(A-B)-2 
