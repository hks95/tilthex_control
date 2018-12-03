%% linearization of system dynamics at trajectory points
    %returns A 2x2xN B 2xN
function [A,B]=linDynamics(modelParams,trajectory,dis_or_conti)
delta=0.01;
% calculate A
for traj_iter=1:1:size(trajectory.x(1,:),2)
    [f_x1_plus,~]=simplePendDynamics(trajectory.x(:,traj_iter)+[delta;0],...
        trajectory.u(:,traj_iter),modelParams);
    [f_x1_min,~]= simplePendDynamics(trajectory.x(:,traj_iter)-[delta;0],...
        trajectory.u(:,traj_iter), modelParams);
    [f_x2_plus,~]=simplePendDynamics(trajectory.x(:,traj_iter)+[0;delta],...
        trajectory.u(:,traj_iter),modelParams);
    [f_x2_min,~]= simplePendDynamics(trajectory.x(:,traj_iter)-[0;delta],...
        trajectory.u(:,traj_iter), modelParams);
    [f_u_plus,~]=simplePendDynamics(trajectory.x(:,traj_iter),...
        trajectory.u(:,traj_iter)+delta,modelParams);
    [f_u_min,~]= simplePendDynamics(trajectory.x(:,traj_iter),...
        trajectory.u(:,traj_iter)-delta, modelParams);
    B(:,traj_iter)=(f_u_plus-f_u_min)/(2*delta);
    A(:,:,traj_iter)=[(f_x1_plus-f_x1_min)/(2*delta) ...
        (f_x2_plus-f_x2_min)/(2*delta)];
    
    %% Discretization- hack from wikipedia
    if nargin>2
        if dis_or_conti=='discrete'
            M=[A(:,:,traj_iter) B(:,traj_iter);...
                zeros(size(B(:,traj_iter),2),size(A,1)+size(B(:,traj_iter),2))]*modelParams.dt;
            M=expm(M);
            A(:,:,traj_iter)=M(1:size(A,1),1:size(A,2));
            B(:,traj_iter)=M(1:size(A,1),end);
        end
    end
    
end
end