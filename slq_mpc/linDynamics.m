%% linearization of system dynamics at trajectory points
    %returns A 2x2xN B 2xN
function [A,B]=linDynamics(modelParams,trajectory,dis_or_conti,Jacobian_x,Jacobian_u)
    
    syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5 u6
    % calculate A
    for traj_iter=1:1:size(trajectory.x(1,:),2) % over T
         A(:,:,traj_iter) = subs(Jacobian_x,[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5 u6],[trajectory.x', trajectory.u']);
         B(:,:,traj_iter) = subs(Jacobian_u,[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5 u6],[trajectory.x', trajectory.u']);

%         A(:,:,traj_iter) = J_x(trajectory.x, trajectory.u);
%         B(:,:,traj_iter) = J_u(trajectory.x);
        
        
        
    %     %% Discretization- hack from wikipedia
    %     if nargin>2
    %         if dis_or_conti=='discrete'
    %             M=[A(:,:,traj_iter) B(:,traj_iter);...
    %                 zeros(size(B(:,traj_iter),2),size(A,1)+size(B(:,traj_iter),2))]*modelParams.dt;
    %             M=expm(M);
    %             A(:,:,traj_iter)=M(1:size(A,1),1:size(A,2));
    %             B(:,traj_iter)=M(1:size(A,1),end);
    %         end
    %     end

    end
end