syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 u1 u2 u3 u4 u5 u6
m = 2;

i1 = 0.011;i2 = 0;i3 = 0; %hex_settings.mass/2 * hex_settings.link_len^2;
i4 = 0;i5= 0.015;i6 = 0; %hex_settings.mass/2 * hex_settings.link_len^2;
i7=0;i8=0;i9 = 0.021; 
F = [ x4, x5, x6, u3/m*(sin(x7)*sin(x9) + cos(x7)*cos(x9)*sin(x8)) - u2/m*(cos(x7)*sin(x9) - cos(x8)*cos(x9)*sin(x7)) + u1/m*cos(x8)*cos(x9), u2/m*(cos(x7)*cos(x9) + sin(x7)*sin(x8)*sin(x9)) - u3/m*(cos(x9)*sin(x7) - cos(x7)*sin(x8)*sin(x9)) + u1/m*cos(x8)*sin(x9), u3/m*cos(x7)*cos(x8) - u1/m*sin(x8) + u2/m*cos(x8)*sin(x7) - 49/5, x10 + x12*cos(x7)*tan(x8) + x11*sin(x7)*tan(x8), x11*cos(x7) - x12*sin(x7), (x12*cos(x7))/cos(x8) + (x11*sin(x7))/cos(x8), -(i2^2*i6*x11^2 + i2^2*i9*x11*x12 - i2*i3*i5*x11^2 + i2*i3*i6*x11*x12 - i2*i3*i8*x11*x12 + i2*i3*i9*x12^2 - i2*i5*i6*x10*x11 - i2*i6^2*x10*x12 - i4*i2*i6*x10^2 + i1*i2*i6*x10*x11 - u6*i2*i6 - i2*i8*i9*x10*x11 - i2*i9^2*x10*x12 - i7*i2*i9*x10^2 + i1*i2*i9*x10*x12 + u5*i2*i9 - i3^2*i5*x11*x12 - i3^2*i8*x12^2 + i3*i5^2*x10*x11 + i3*i5*i6*x10*x12 + i4*i3*i5*x10^2 - i1*i3*i5*x10*x11 + u6*i3*i5 + i3*i8^2*x10*x11 + i3*i8*i9*x10*x12 + i7*i3*i8*x10^2 - i1*i3*i8*x10*x12 - u5*i3*i8 + i5^2*i9*x11*x12 - i5*i6*i8*x11*x12 + i5*i6*i9*x12^2 - i5*i8*i9*x11^2 - i5*i9^2*x11*x12 - i7*i5*i9*x10*x11 + i4*i5*i9*x10*x12 - u4*i5*i9 - i6^2*i8*x12^2 + i6*i8^2*x11^2 + i6*i8*i9*x11*x12 + i7*i6*i8*x10*x11 - i4*i6*i8*x10*x12 + u4*i6*i8)/(i1*i5*i9 - i1*i6*i8 - i2*i4*i9 + i2*i6*i7 + i3*i4*i8 - i3*i5*i7), (i1^2*i6*x10*x11 + i1^2*i9*x10*x12 - i1*i3*i4*x10*x11 + i1*i3*i6*x11*x12 - i1*i3*i7*x10*x12 + i1*i3*i9*x12^2 - i1*i4*i6*x10^2 - i1*i6^2*x10*x12 - i5*i1*i6*x10*x11 + i2*i1*i6*x11^2 - u6*i1*i6 - i1*i7*i9*x10^2 - i1*i9^2*x10*x12 - i8*i1*i9*x10*x11 + i2*i1*i9*x11*x12 + u5*i1*i9 - i3^2*i4*x11*x12 - i3^2*i7*x12^2 + i3*i4^2*x10^2 + i3*i4*i6*x10*x12 + i5*i3*i4*x10*x11 - i2*i3*i4*x11^2 + u6*i3*i4 + i3*i7^2*x10^2 + i3*i7*i9*x10*x12 + i8*i3*i7*x10*x11 - i2*i3*i7*x11*x12 - u5*i3*i7 + i4^2*i9*x10*x12 - i4*i6*i7*x10*x12 + i4*i6*i9*x12^2 - i4*i7*i9*x10*x11 - i4*i9^2*x11*x12 - i8*i4*i9*x11^2 + i5*i4*i9*x11*x12 - u4*i4*i9 - i6^2*i7*x12^2 + i6*i7^2*x10*x11 + i6*i7*i9*x11*x12 + i8*i6*i7*x11^2 - i5*i6*i7*x11*x12 + u4*i6*i7)/(i1*i5*i9 - i1*i6*i8 - i2*i4*i9 + i2*i6*i7 + i3*i4*i8 - i3*i5*i7), -(i1^2*i5*x10*x11 + i1^2*i8*x10*x12 - i1*i2*i4*x10*x11 + i1*i2*i5*x11^2 - i1*i2*i7*x10*x12 + i1*i2*i8*x11*x12 - i1*i4*i5*x10^2 - i1*i5^2*x10*x11 - i6*i1*i5*x10*x12 + i3*i1*i5*x11*x12 - u6*i1*i5 - i1*i7*i8*x10^2 - i1*i8^2*x10*x11 - i9*i1*i8*x10*x12 + i3*i1*i8*x12^2 + u5*i1*i8 - i2^2*i4*x11^2 - i2^2*i7*x11*x12 + i2*i4^2*x10^2 + i2*i4*i5*x10*x11 + i6*i2*i4*x10*x12 - i3*i2*i4*x11*x12 + u6*i2*i4 + i2*i7^2*x10^2 + i2*i7*i8*x10*x11 + i9*i2*i7*x10*x12 - i3*i2*i7*x12^2 - u5*i2*i7 + i4^2*i8*x10*x12 - i4*i5*i7*x10*x12 + i4*i5*i8*x11*x12 - i4*i7*i8*x10*x11 - i4*i8^2*x11^2 - i9*i4*i8*x11*x12 + i6*i4*i8*x12^2 - u4*i4*i8 - i5^2*i7*x11*x12 + i5*i7^2*x10*x11 + i5*i7*i8*x11^2 + i9*i5*i7*x11*x12 - i6*i5*i7*x12^2 + u4*i5*i7)/(i1*i5*i9 - i1*i6*i8 - i2*i4*i9 + i2*i6*i7 + i3*i4*i8 - i3*i5*i7)];
X = [x1;x2;x3;x4;x5;x6;x7;x8;x9;x10;x11;x12];
U = [u1;u2;u3;u4;u5;u6];

for i=1:12
    for j=1:12
        J_x(i,j) = jacobian(F(i),X(j));
    end
end

for i=1:12
    for j=1:6
        J_u(i,j) = jacobian(F(i),U(j));
    end
end