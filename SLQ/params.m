%%%%%%%%%%%%
%  params  %
%%%%%%%%%%%%
global m g l b xg xn;

m = 1;
g = 9.81;
l = 1;
b = 0.1;
xg = [-pi; 0];
xn = [pi; 0];


global dt num_step t_step;
dt = 0.1;
num_step = 50;
t_step = [0:dt:num_step*dt-dt]';


global R S Q q r;
R = 1;
S = 0;
Q = eye(2);
q = Q;
r = R;