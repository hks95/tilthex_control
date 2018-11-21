function [x_goal, u_goal, x_nom, u_nom] = generate_traj()
    global num_step;
    
    A = [];
    B = [];
    Aeq = [];
    beq = [];

    % upper and lower bounds
    lb = -ones(num_step, 3);
    lb(:,1:2) = lb(:,1:2)*inf; 
    lb(:,3) = lb(:,3)*3;

    ub = ones(num_step, 3);
    ub(:,1:2) = ub(:,1:2)*inf;
    ub(:,3) = ub(:,3)*3;

    options = optimoptions(@fmincon, 'TolFun', 0.00000001, 'MaxIter', 1000000, ... 
                           'MaxFunEvals', 100000, 'Display', 'iter', ...
                           'DiffMinChange', 0.001, 'Algorithm', 'sqp');
                       
    % generate desired traj and action for [-pi; 0]
    in(:,1:2) = zeros(num_step,2);
    in(:,3) = ones(num_step,1);
    
    for idx = 1:num_step
        in(idx,2) = -pi * (idx/(num_step));
    end

%     goal 
    o1 = fmincon(@energy_func, in, A, B, Aeq, beq, lb, ub, @mycon_goal, options);   
    x_goal = o1(:,1:2);
    u_goal = o1(:,3);

    for idx = 1:num_step
        in(idx,2) = pi * (idx/(num_step));
    end

%     nominal
    o2 = fmincon(@energy_func, in, A, B, Aeq, beq, lb, ub, @mycon_nom, options);
    x_nom = o2(:,1:2);
    u_nom = o2(:,3);

end