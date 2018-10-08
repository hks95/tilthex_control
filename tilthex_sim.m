clc;
clear;
close all;
rng('default');


%% Settings for the simulator
% load ./data/features.mat;

%% Initialization
tilthex_sim_init;


%% Start simulation

while my_simulator.time < sim_duration + 1e-10
    my_simulator.oneTimeStepForward();
    drawnow;

end