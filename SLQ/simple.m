% simple pendulum equation
function out = simple(t, x)
    global m g l b K xg;
    u = -K*(x-xg);
    
    x1 = x(2);
    x2 = (u - b*x(2) - m*g*l*sin(x(1))/m/l/l);
end