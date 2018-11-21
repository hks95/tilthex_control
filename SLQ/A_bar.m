function out = A_bar(x)
    global m g l b;
    out = [0, 1; ...
           -m*g*l*cos(x(2))/m/l/l, -b/m/l/l];
end