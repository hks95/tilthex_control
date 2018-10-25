%% Entire simulator adapted from https://github.com/ke-sun/quadrotor_simulator

clc;
clear;
close all;
rng('default');

%% Initialization
tilthex_sim_init;
N = 10000;
w = 2*pi*N/60;
u = [w w w w w w];

%% Start simulation

while my_simulator.time < sim_duration + 1e-10
    my_simulator.oneTimeStepForward(u);
    drawnow;

end