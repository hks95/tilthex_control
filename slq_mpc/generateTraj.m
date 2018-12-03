function [x,u]=generateTraj(modelParams, dynamics, x_goal)
%% direct collocation for simple and augmented pendulum
%initialize

% 6 inputs, 1 for each propeller
% 12 states
    initial_traj = [zeros(6,modelParams.N); zeros(12, modelParams.N)];

    loss = @(initial_traj)costFunction(initial_traj,modelParams);

    A=[];
    b=[];
    Aeq=[];
    beq=[];
    lb = [repmat(-1*modelParams.u_lim, 6, modelParams.N) ;-inf(12, modelParams.N)];
    ub = [repmat(1*modelParams.u_lim, 6, modelParams.N) ;inf(12, modelParams.N)];

    nonlin_constraints = @(initial_traj)nonlincst(initial_traj, dynamics, x_goal,modelParams);

    options =optimoptions(@fmincon,'TolFun', 0.00000001,'MaxIter', 10000, ...
                          'MaxFunEvals', 100000,'Display','iter', ...
                          'DiffMinChange', 0.001,'Algorithm', 'sqp');

    [nom_traj, fval, ef, op]=fmincon(loss, initial_traj, A, b, Aeq, beq,...
                                     lb, ub, nonlin_constraints, options);

    u=nom_traj(1:6,:);
    x=nom_traj(7:18,:);
end