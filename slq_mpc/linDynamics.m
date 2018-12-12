%% linearization of system dynamics at trajectory points
    %returns A 2x2xN B 2xN
function [A,B]=linDynamics(modelParams,trajectory,dis_or_conti)
% function [A,B]=linDynamics(modelParams,trajectory,dis_or_conti, Jacobian_x,Jacobian_u)
    
    dt = modelParams.dt;
    % calculate A
    for traj_iter=1:1:size(trajectory.x(1,:),2) % over T
%         if size(trajectory.x,1) ~= 12 || size(trajectory.u,1) ~= 6
%             fuck = 1
%         end
        
%          A(:,:,traj_iter) = subs(Jacobian_x,[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5 u6],[trajectory.x', trajectory.u']);
%          B(:,:,traj_iter) = subs(Jacobian_u,[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5 u6],[trajectory.x', trajectory.u']);

         
%          A(:,:,traj_iter) = J_x(trajectory.x, trajectory.u);
%          B(:,:,traj_iter) = J_u(trajectory.x);
         
         A_cont = J_x(trajectory.x, trajectory.u);
         B_cont = J_u(trajectory.x);
         
        A(:,:,traj_iter) = expm(A_cont*dt);
        B(:,:,traj_iter) = pinv(A_cont)*(A(:,:,traj_iter) - eye(12))*B_cont;
%          
        
        
        
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