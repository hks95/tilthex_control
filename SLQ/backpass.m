function [P, p, K, ll] = backpass(x_nom)

    global num_step t_step Q R r q line_steps alpha_d; 
    
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

        p_curr = q + At'*p(i+1,:)' + K(i,:)'*H*ll(i) + K(i,:)'*g + G'*ll(i);  % should be [2x1]
        p(i,:) = reshape(p_curr, [1,2]);
        
%         %Line search 
        alpha = 1;
        for ls = 1:line_steps
            %update control
            u = K(i,:)*();
            alpha = alpha/alpha_d; %decrease alpha by alpha_d
        end
    end
end
