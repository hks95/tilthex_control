function out = J_u (x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12)

    % column 1
	out(1:3,1) = zeros(3,1);
    out(4,1) = cos(x8)*cos(x9)/2;
    out(5,1) = cos(x8)*sin(x9)/2;
    out(6,1) = -sin(x8)/2;
    out(7:12,1) = zeros(6,1);
    
    % column 2
    out(1:3,2) = zeros(3,1);
    out(4,1) = (cos(x8)*cos(x9)*sin(x7))/2 - (cos(x7)*sin(x9))/2;
    out(5,1) = (cos(x7)*cos(x9))/2 + (sin(x7)*sin(x8)*sin(x9))/2;
    out(6,1) = (cos(x8)*sin(x7))/2;
    out(7:12,2) = zeros(6,1);
    
    % column 3
    out(1:3,3) = zeros(3,1);
    out(4,1) = (sin(x7)*sin(x9))/2 + (cos(x7)*cos(x9)*sin(x8))/2;
    out(5,1) = (cos(x7)*sin(x8)*sin(x9))/2 - (cos(x9)*sin(x7))/2;
    out(6,1) = (cos(x7)*cos(x8))/2;
    out(7:12,3) = zeros(6,1);
    
    % column 4
    out(1:9,4) = zeros(9,1);
    out(10,4) = 332041393326771929088/3652455326594490625;
    out(11:12,4) = zeros(2,1);
    
    % column 5
    out(1:10,5) = zeros(10,1);
    out(11,5) = 110680464442257309696/1660206966633859375;
    out(12,5) = 0;
    
    % column 6
    out(1:11,6) = zeros(11,1);
    out(12,6) = 110680464442257309696/2324289753287403125;
end