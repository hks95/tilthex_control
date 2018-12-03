function [c,ceq] = nonlincst(nom_traj, dynamics, x_goal, modelParams)

    u = nom_traj(1:6,:);    
    xNext = nom_traj(7:18,:);
    
    BoundaryFinal = x_goal - xNext(:,end);
    BoundaryInit = modelParams.x_init - xNext(:,1);
    delta = hermiteSimpsonDefects(xNext, u, dynamics, modelParams);
    c = [];  %No inequality constraints
    
    ceq = [BoundaryInit; ...
           reshape(delta, 12*modelParams.N-12, 1); ... % no including the first state, the line above takes care of it
           BoundaryFinal; ...
           u(end)];
end