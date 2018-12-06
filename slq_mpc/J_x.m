function Jx = J_x(x, u)
    tic
    x1 = x(1);
    x2 = x(2);
    x3 = x(3);
    x4 = x(4);
    x5 = x(5);
    x6 = x(6);
    x7 = x(7);
    x8 = x(8);
    x9 = x(9);
    x10 = x(10);
    x11 = x(11);
    x12 = x(12);
   
    u1 = u(1);
    u2 = u(2);
    u3 = u(3);
%     u4 = u(4);
%     u5 = u(5);
%     u6 = u(6);
    
    
Jx = [ 0, 0, 0, 1, 0, 0,                                                                                                         0,                                                                                        0,                                                                                                                                0,   0,               0,               0;
 0, 0, 0, 0, 1, 0,                                                                                                         0,                                                                                        0,                                                                                                                                0,   0,               0,               0;
 0, 0, 0, 0, 0, 1,                                                                                                         0,                                                                                        0,                                                                                                                                0,   0,               0,               0;
 0, 0, 0, 0, 0, 0,   (u2*(sin(x7)*sin(x9) + cos(x7)*cos(x9)*sin(x8)))/2 + (u3*(cos(x7)*sin(x9) - cos(x9)*sin(x7)*sin(x8)))/2, (u3*cos(x7)*cos(x8)*cos(x9))/2 - (u1*cos(x9)*sin(x8))/2 + (u2*cos(x8)*cos(x9)*sin(x7))/2, (u3*(cos(x9)*sin(x7) - cos(x7)*sin(x8)*sin(x9)))/2 - (u2*(cos(x7)*cos(x9) + sin(x7)*sin(x8)*sin(x9)))/2 - (u1*cos(x8)*sin(x9))/2,   0,               0,               0;
 0, 0, 0, 0, 0, 0, - (u2*(cos(x9)*sin(x7) - cos(x7)*sin(x8)*sin(x9)))/2 - (u3*(cos(x7)*cos(x9) + sin(x7)*sin(x8)*sin(x9)))/2, (u3*cos(x7)*cos(x8)*sin(x9))/2 - (u1*sin(x8)*sin(x9))/2 + (u2*cos(x8)*sin(x7)*sin(x9))/2, (u3*(sin(x7)*sin(x9) + cos(x7)*cos(x9)*sin(x8)))/2 - (u2*(cos(x7)*sin(x9) - cos(x9)*sin(x7)*sin(x8)))/2 + (u1*cos(x8)*cos(x9))/2,   0,               0,               0;
 0, 0, 0, 0, 0, 0,                                                           (u2*cos(x7)*cos(x8))/2 - (u3*cos(x8)*sin(x7))/2,                       - (u1*cos(x8))/2 - (u3*cos(x7)*sin(x8))/2 - (u2*sin(x7)*sin(x8))/2,                                                                                                                                0,   0,               0,               0;
 0, 0, 0, 0, 0, 0,                                                                 x11*cos(x7)*tan(x8) - x12*sin(x7)*tan(x8),                                x12*cos(x7)*(tan(x8)^2 + 1) + x11*sin(x7)*(tan(x8)^2 + 1),                                                                                                                                0,   1, sin(x7)*tan(x8), cos(x7)*tan(x8);
 0, 0, 0, 0, 0, 0,                                                                               - x12*cos(x7) - x11*sin(x7),                                                                                        0,                                                                                                                                0,   0,         cos(x7),        -sin(x7);
 0, 0, 0, 0, 0, 0,                                                             (x11*cos(x7))/cos(x8) - (x12*sin(x7))/cos(x8),                        (x12*cos(x7)*sin(x8))/cos(x8)^2 + (x11*sin(x7)*sin(x8))/cos(x8)^2,                                                                                                                                0,   0, sin(x7)/cos(x8), cos(x7)/cos(x8);
 0, 0, 0, 0, 0, 0,                                                                                                         0,                                                                                        0,                                                                                                                                0,   0,            -x12,            -x11;
 0, 0, 0, 0, 0, 0,                                                                                                         0,                                                                                        0,                                                                                                                                0, x12,               0,             x10;
 0, 0, 0, 0, 0, 0,                                                                                                         0,                                                                                        0,                                                                                                                                0,   0,               0,               0];



%     out = zeros(12,12);
%     
%     % column 1
% %     out(:,1) = 0;
%     
%     % column 2
% %     out(:,2) = zeros(12,1);
%     
%     % column 3
% %     out(:,3) = zeros(12,1)
%     
%     % column 4
%     out(1,4) = 1;
% %     out(2:12,4) = zeros(11,1);
%     
%     % column 5
%     out(1,5) = 0;
%     out(2,5) = 1;
% %     out(3:12,5) = zeros(10,1);
%     
%     % column 6
% %     out(1:2,6) = zeros(2,1);
%     out(3,6) = 1;
% %     out(4:12,6) = zeros(9,1);
%     
%     % column 7
% %     out(1:3,7) = zeros(3,1);
%     out(4,7) = (u2*(sin(x7)*sin(x9) + cos(x7)*cos(x8)*cos(x9)))/2 + (u3*(cos(x7)*sin(x9) - cos(x9)*sin(x7)*sin(x8)))/2;
%     out(5,7) = - (u2*(cos(x9)*sin(x7) - cos(x7)*sin(x8)*sin(x9)))/2 - (u3*(cos(x7)*cos(x9) + sin(x7)*sin(x8)*sin(x9)))/2;
%     out(6,7) = (u2*cos(x7)*cos(x8))/2 - (u3*cos(x8)*sin(x7))/2;
%     out(7,7) = x11*cos(x7)*tan(x8) - x12*sin(x7)*tan(x8);
%     out(8,7) = -x12*cos(x7) - x11*sin(x7);
%     out(9,7) = (x11*cos(x7))/cos(x8) - (x12*sin(x7))/cos(x8);
% %     out(10:12,7) = zeros(3,1); 
%     
%     % column 8
% %     out(1:3,8) = zeros(3,1);
%     out(4,8) = (u3*cos(x7)*cos(x8)*cos(x9))/2 - (u1*cos(x9)*sin(x8))/2 - (u2*cos(x9)*sin(x7)*sin(x8))/2;
%     out(5,8) = (u3*cos(x7)*cos(x8)*sin(x9))/2 - (u1*sin(x8)*sin(x9))/2 + (u2*cos(x8)*sin(x7)*sin(x9))/2;
%     out(6,8) = - (u1*cos(x8))/2 - (u3*cos(x7)*sin(x8))/2 - (u2*sin(x7)*sin(x8))/2;
%     out(7,8) = x12*cos(x7)*(tan(x8)^2 + 1) + x11*sin(x7)*(tan(x8)^2 + 1);
% %     out(8,8) = 0;
%     out(9,8) = (x12*cos(x7)*sin(x8))/cos(x8)^2 + (x11*sin(x7)*sin(x8))/cos(x8)^2;
% %     out(10:12,8) = zeros(3,1);
%     
%     % column 9
% %     out(1:3,9) = zeros(3,1);
%     out(4,9) = (u3*(cos(x9)*sin(x7) - cos(x7)*sin(x8)*sin(x9)))/2 - (u2*(cos(x7)*cos(x9) + cos(x8)*sin(x7)*sin(x9)))/2 - (u1*cos(x8)*sin(x9))/2;
%     out(5,9) = (u3*(sin(x7)*sin(x9) + cos(x7)*cos(x9)*sin(x8)))/2 - (u2*(cos(x7)*sin(x9) - cos(x9)*sin(x7)*sin(x8)))/2 + (u1*cos(x8)*cos(x9))/2;
% %     out(6:12,9) = zeros(7,1); 
%     
%     % column 10
% %     out(1:6,10) = zeros(6,1);
%     out(7,10) = 1;
% %     out(8:10,10) = zeros(3,1);
%     out(11,10) = -(5454333287714440*x12)/8181499931571659;
%     out(12,10) = (3116761878693965*x11)/16362999863143318;
%     
%     % column 11
% %     out(1:6,11) = zeros(6,1);
%     out(7,11) = sin(x7)*tan(x8);
%     out(8,11) = cos(x7);
%     out(9,11) = sin(x7)/cos(x8);
%     out(10,11) = (6*x12)/11;
% %     out(11,11) = 0;
%     out(12,11) = (3116761878693965*x10)/16362999863143318;
%     
%     % column 12
% %     out(1:6,12) = zeros(6,1);
%     out(7,12) = cos(x7)*tan(x8);
%     out(8,12) = -sin(x7);
%     out(9,12) = cos(x7)/cos(x8);
%     out(10,12) = (6*x11)/11;
%     out(11,12) = -(5454333287714440*x10)/8181499931571659;
% %     out(12,12) = 0;
    toc
end