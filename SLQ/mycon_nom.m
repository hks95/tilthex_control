function [c,ceq] = mycon_goal(opt_me)
    global dt num_step xn;
    c = [];      % Compute nonlinear inequalities at x.
    xs = opt_me(:, 1:2);
    us = opt_me(:, 3);
    deltK = zeros(num_step,2);

    for i = 1:num_step-1
        x_k = xs(i,:);
        x_k1 = xs(i+1,:);
        f_k = simple_dircol(x_k, us(i));
        f_k1 = simple_dircol(x_k1, us(i+1));
        x_ck = (1/2) *(x_k + x_k1) + dt/8 * (f_k - f_k1);
        u_ck = (us(i) + us(i+1))/2;
        f_ck = simple_dircol(x_ck, u_ck);
        deltK(i,:) = (x_k - x_k1) + dt/6 * (f_k + 4*f_ck + f_k1);
       
    end
    
    ceq = [deltK; 
           xs(end,:) - xn'; 
           xs(1,:)]; 
end