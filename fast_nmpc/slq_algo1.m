function [act_traj,u_ff, u_fb]=slq_algo1(nom_traj,modelParams, u_ff_prev, u_fb_prev)
%% writing a good code
% all functions, structs and classes- Camel case
% all variables-underscore

close all
set(0,'DefaultFigureWindowStyle','docked');
%% main
if nargin==0
    modelParams=setParams();
else
    u_ff=u_ff_prev;
    u_fb=u_fb_prev;
end
converged=0;

%% handles for dynamics
simple_pend=@(x,u)simplePendDynamics(x,u, modelParams);
aug_pend=@(x,u)augPendDynamics(x,u, modelParams);

%% generate trajectory
%to get the full trajectory- add x_init in each traj.x
if nargin==0
    if modelParams.gen_traj
        [nom_traj.x, nom_traj.u]=generateTraj(modelParams, simple_pend,[pi;0] );
        save('nominal.mat','nom_traj');
        if modelParams.traj_track
            [des_traj.x,des_traj.u]=generateTraj(modelParams, aug_pend, modelParams.goal);
            save('desired.mat','des_traj');
        else
            des_traj.x=repmat(modelParams.goal,1,modelParams.N);
            des_traj.u=zeros(1,modelParams.N);
            save('desired.mat','des_traj');
        end
    else
        load('nominal.mat','nom_traj');
        load('desired.mat','des_traj');
        assert(abs(des_traj.x(1,end)-modelParams.goal(1))<1e-5,'gen traj should be on');
    end
else % MPC stuff
    if modelParams.gen_traj
        if modelParams.traj_track
            [des_traj.x,des_traj.u]=generateTraj(modelParams, aug_pend, modelParams.goal);
            save('desired.mat','des_traj');
        else
            des_traj.x=repmat(modelParams.goal,1,modelParams.N);
            des_traj.u=zeros(1,modelParams.N);
            save('desired.mat','des_traj');
        end
    else
        load('desired.mat','des_traj');
    end

    % concatenating desired traj vector as per time horizon (MPC)
    des_traj.x=des_traj.x(:,size(des_traj.x(1,:),2)-modelParams.N+1:end);
    des_traj.u=des_traj.u(:,size(des_traj.u(1,:),2)-modelParams.N+1:end);
end

%% plotting


        
if modelParams.viz
    figure('Name','states and input');
    %
    subplot(2,2,1);
    plot([1:1:modelParams.N],nom_traj.u,'b','LineWidth',2,'DisplayName','Initial')
    hold on;
    plot([1:1:modelParams.N],des_traj.u,'r','LineWidth',2,'DisplayName','Desired')
    legend('show');
    title('control versus time - given');
    hold off;
    %
    subplot(2,2,2);
%     plot(nom_traj.x(1,:),nom_traj.x(2,:),'b','LineWidth',2,'DisplayName','Initial')
    hold on;
    if modelParams.traj_track
        plot(des_traj.x(1,:),des_traj.x(2,:),'r','LineWidth',2,'DisplayName','Desired');
    else
        plot(modelParams.goal(1), modelParams.goal(2),'r*','DisplayName','Desired');
    end
    if modelParams.wp_bool
        wp=init_waypoints(modelParams);
        for wp_iter=1:modelParams.num_wp
            hold on;
            plot(wp{wp_iter}.state(1),wp{wp_iter}.state(2),'g*');
        end
        
    end
    legend('Desired','Way points');
    title('state space - given')
    hold off;
    %
    subplot(2,2,3);
    title('control versus time-actual');
    %
    subplot(2,2,4);
    title('state space-actual');
    drawnow
end

%% loop
%repeat until max number of iterations or converged (l(t)<l_t)
max_iter=1;
while max_iter<100
    t_start=tic;
    %simulate the trajectory forward
    nom_traj.x(:,1)=modelParams.x_init;
    for time_iter=1:modelParams.N-1
        [~, nom_traj.x(:,time_iter+1)]=simplePendDynamics(nom_traj.x(:,time_iter),...
            nom_traj.u(:,time_iter),modelParams);
    end
    if max_iter==1 & modelParams.viz
        subplot(2,2,2);
        hold on;
        plot(nom_traj.x(1,:),nom_traj.x(2,:),'b','LineWidth',2,'DisplayName','Initial')
        legend('show');
        hold off;
    end
    % linearize the dynamics
    [A,B]=linDynamics(modelParams,nom_traj,'discrete');
    
    %compute cost function
    J_nom=computeActualCost(nom_traj,des_traj,modelParams);
    if modelParams.printf
        fprintf('At Iteration %d, cost= %f \n',max_iter,J_nom);
    end
    % Quadratize cost function along the trajectory
    x_diff=nom_traj.x-des_traj.x;
    x_diff(1,:)=wrapToPi(x_diff(1,:));
    u_diff=nom_traj.u-des_traj.u;
    
    p1=zeros(2,2,modelParams.N);% corresponds to P in the psuedocode
    p1(:,:,modelParams.N)=2*modelParams.Qf;
    p2=zeros(2,modelParams.N);% corresponds to bold p in the psuedocode
    p2(:,modelParams.N)=2*modelParams.Qf*(x_diff(:,end));
    
    q_t=2*bsxfun(@times, diag(modelParams.Qt), x_diff);
    r_t=2*bsxfun(@times, diag(modelParams.Rt), u_diff);
    Q=2*modelParams.Qt;
    R=2*modelParams.Rt;
    
    %initialize ricatti variables
    K=zeros(modelParams.N-1,2);
    l=zeros(modelParams.N-1,1);
    
    %Backwards solve the Ricatti-like equations
    for ricatti_iter=modelParams.N-1:-1:1
        %H-scalar
        H=R+B(:,ricatti_iter)'*p1(:,:,ricatti_iter+1)*B(:,ricatti_iter);
        %G-1x2
        G=B(:,ricatti_iter)'*p1(:,:,ricatti_iter+1)*A(:,:,ricatti_iter);
        %g-scalar
        g=r_t(ricatti_iter)+B(:,ricatti_iter)'*p2(:,ricatti_iter+1);
        %K-1x2
        K(ricatti_iter,:)=-inv(H)*G;
        %l-scalar
        l(ricatti_iter)=-inv(H)*g;
        %p1-2x2
        p1(:,:,ricatti_iter)=Q+...
            A(:,:,ricatti_iter)'*p1(:,:,ricatti_iter+1)*A(:,:,ricatti_iter)...
            +K(ricatti_iter,:)'*H*K(ricatti_iter,:)+...
            +K(ricatti_iter,:)'*G+ G'*K(ricatti_iter,:);
        %p2-2x1
        p2(:,ricatti_iter)=q_t(:,ricatti_iter)+...
            A(:,:,ricatti_iter)'*p2(:,ricatti_iter+1)...
            + 2*K(ricatti_iter,:)'*H*l(ricatti_iter)+...
            K(ricatti_iter,:)'*g+...
            2*G'*l(ricatti_iter);
    end
    
    %%Line Search
    alpha=1;
    for ls_iter=1:modelParams.ls_steps
        act_traj.x(:,1)=modelParams.x_init;
        for sim_iter=1:modelParams.N-1
            x_diff=act_traj.x(:,sim_iter)-nom_traj.x(:,sim_iter);
            % I think here wrapToPi should not be done
            act_traj.u(sim_iter)= nom_traj.u(sim_iter)+alpha*l(sim_iter)+...
                K(sim_iter,:)*(x_diff);
            if abs(act_traj.u(sim_iter))>modelParams.u_lim
                act_traj.u(sim_iter)=sign(act_traj.u(sim_iter))*modelParams.u_lim;
            end
            [~,act_traj.x(:,sim_iter+1)]=simplePendDynamics(act_traj.x(:,sim_iter),...
                act_traj.u(sim_iter),modelParams);
        end
        act_traj.u(modelParams.N)=0;
        J_actual=computeActualCost(act_traj,des_traj,modelParams);
        if J_actual<J_nom
            t_complete=toc(t_start);
            if modelParams.printf
                fprintf("the time taken by this iteration = %f \n",t_complete);
            end
            u_ff=alpha*l;
            u_fb=K;
            break
        elseif ls_iter==modelParams.ls_steps && J_actual>=J_nom
            act_traj.u=nom_traj.u;
            act_traj.x=nom_traj.x;
            converged=1;
            break
        end
        alpha=alpha/modelParams.alpha_d;
    end
    
    if modelParams.viz
        subplot(2,2,3);
        plot([1:1:modelParams.N],act_traj.u,'LineWidth',2,'DisplayName','sim'+string(max_iter))
        legend('show');
        subplot(2,2,4);
        plot(act_traj.x(1,:),act_traj.x(2,:),'LineWidth',2,'DisplayName','sim'+string(max_iter))
        legend('show');
        drawnow
    end
    
    if converged
        break
    end
    
    nom_traj.u=act_traj.u;
    max_iter=max_iter+1;
end

%% plot and animate the output
save('simulated_traj.mat','act_traj');
if modelParams.viz
    subplot(2,2,2);
    hold on;
    plot(act_traj.x(1,:),act_traj.x(2,:),'k','LineWidth',2,'DisplayName','Simulated')
    legend('show');
    hold off;
    subplot(2,2,1);
    hold on;
    plot([1:1:modelParams.N],act_traj.u,'k','LineWidth',2,'DisplayName','Simulated')
    legend('show');
    hold off;
    
    % figure 2
    figure('Name','states versus time');
    subplot(2,1,1);
    hold on;
    plot([1:1:length(act_traj.x(1,:))],wrapToPi(act_traj.x(1,:)),'k','LineWidth',2);
    plot(modelParams.N, modelParams.goal(1),'r*');
    if modelParams.wp_bool
        for wp_iter=1:modelParams.num_wp
            plot(wp{wp_iter}.t_p*modelParams.T,wp{wp_iter}.state(1),'g*');
        end
    end
    legend('position','desired','waypoints');
    title('position versus time');
    hold off;
    subplot(2,1,2);
    hold on;
    plot([1:1:length(act_traj.x(2,:))],act_traj.x(2,:),'k','LineWidth',2);
    plot(modelParams.N, modelParams.goal(2),'r*');
    if modelParams.wp_bool
        for wp_iter=1:modelParams.num_wp
            plot(wp{wp_iter}.t_p*modelParams.T,wp{wp_iter}.state(2),'g*');
        end
    end
    legend('velocity','desired','waypoints');
    title('velocity versus time');
    hold off;
    
    %figure 3
    fig_pend=figure('Name','slq');
    pend_animation(act_traj.x(1,:),fig_pend);
end
end