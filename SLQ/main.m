close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%
%  run to load params  %
%%%%%%%%%%%%%%%%%%%%%%%%
params
preload = true;

%%%%%%%%%%%%%%%%%%%%%%%%%
%  generate trajectory  %
%%%%%%%%%%%%%%%%%%%%%%%%%
if preload == true
    load('u_goal');
    load('u_nom');
    load('x_goal');
    load('x_nom');
else
    [x_goal, u_goal, x_nom, u_nom] = generate_traj;
end

global x_des u_des x_act u_act Q R q r;
x_des = x_goal;
u_des = u_goal;
x_act = x_nom;
u_act = u_nom;

P = zeros(num_step+1, 4);
P(num_step+1, :) = reshape(Q, [1,4]);  % have to change to proper init

p = zeros(num_step+1, 2);
temp = -2*Q*x_nom(end,:)';
p(num_step+1,:) = reshape(temp, [1,2]);  % have to change to proper init

% r = zeros(num_step, 2);
H = 0;
G = 0;
g = 0;
K = zeros(num_step, 2);
ll = zeros(num_step, 2);

% reverse the time
for i = num_step:-1:1

    % current time step
    curr_time = t_step(i);
    
    xnom = interp1(t_step, x_nom, curr_time);
    
    At = A_bar(xnom);
    Bt = B_bar();
    
    G = Bt'*P(i+1)*At;
    H = R + Bt'*P(i+1)*Bt;
    K(i,:) = -inv(H)*G;
    
    P_curr = Q + At'*P(i+1)*At + K(i,:)'*H*K(i,:) + K(i,:)'*G + G'*K(i,:);
    P(i,:) = reshape(P_curr, [1, 4]);
    
    g = r + Bt'*p(i+1,:)';  % have to reshape little p
    
    ll(i) = -inv(H)*g;
    
    p_curr = q + At'*p(i+1) + K(i,:)'*H*l + K(i,:)'*g + G'*ll(i);
    
    
    
    
    
    
end




        




