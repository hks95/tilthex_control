function out = simple_dircol(x, u)
    global m g l b;
    x2 = u - b*x(2) - m*g*l*sin(x(1))/m/l/l;
    out = [x(2) x2];
end