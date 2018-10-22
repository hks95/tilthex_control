function [ ] = drawTilthex( obj )
%DRAWQUADROTOR draws the tilt hexarotor in the figure
%
%

% convert FRD to XYZ
R1 = [cosd(90) sind(90) 0;-sind(90) cosd(90) 0;0 0 1];
R2 = [cosd(180) 0 sind(180);0 1 0;-sind(180) 0 cosd(180)];
Rt = R1*R2;

% The orientation and translation of the body frame
R = obj.state.R;
t = obj.state.position;
t = Rt*t; %convert to XYZ while drawing, dynamics is in FRD

% Find the cooridnates of the end points of the 4 links in the inertial
% frame
end_point1 = R * obj.link1_body + t;
end_point2 = R * obj.link2_body + t;
end_point3 = R * obj.link3_body + t;
end_point4 = R * obj.link4_body + t;
end_point5 = R * obj.link5_body + t;
end_point6 = R * obj.link6_body + t;

% Udpate the links
set(obj.link1,'Parent',obj.world_axes_handle,'XData',[t(1) end_point1(1)], 'YData', [t(2) end_point1(2)], 'ZData', [t(3) end_point1(3)], 'visible','on');
set(obj.link2,'Parent',obj.world_axes_handle,'XData',[t(1) end_point2(1)], 'YData', [t(2) end_point2(2)], 'ZData', [t(3) end_point2(3)], 'visible','on');
set(obj.link3,'Parent',obj.world_axes_handle,'XData',[t(1) end_point3(1)], 'YData', [t(2) end_point3(2)], 'ZData', [t(3) end_point3(3)], 'visible','on');
set(obj.link4,'Parent',obj.world_axes_handle,'XData',[t(1) end_point4(1)], 'YData', [t(2) end_point4(2)], 'ZData', [t(3) end_point4(3)], 'visible','on');
set(obj.link5,'Parent',obj.world_axes_handle,'XData',[t(1) end_point5(1)], 'YData', [t(2) end_point5(2)], 'ZData', [t(3) end_point5(3)], 'visible','on');
set(obj.link6,'Parent',obj.world_axes_handle,'XData',[t(1) end_point6(1)], 'YData', [t(2) end_point6(2)], 'ZData', [t(3) end_point6(3)], 'visible','on');

% update rotors
rotor_end_point1 = R *Rt*obj.rotor1 * obj.z_axis_rotor1 + end_point1;
rotor_end_point2 = R *Rt*obj.rotor2 * obj.z_axis_rotor2 + end_point2;
rotor_end_point3 = R *Rt*obj.rotor3 * obj.z_axis_rotor3 + end_point3;
rotor_end_point4 = R *Rt*obj.rotor4 * obj.z_axis_rotor4 + end_point4;
rotor_end_point5 = R *Rt*obj.rotor5 * obj.z_axis_rotor5 + end_point5;
rotor_end_point6 = R *Rt*obj.rotor6 * obj.z_axis_rotor5 + end_point6;

set(obj.z_rotor1_fig,'Parent',obj.world_axes_handle,'XData',[end_point1(1) rotor_end_point1(1)], 'YData', [end_point1(2) rotor_end_point1(2)], 'ZData', [end_point1(3) rotor_end_point1(3)], 'visible','on');
set(obj.z_rotor2_fig,'Parent',obj.world_axes_handle,'XData',[end_point2(1) rotor_end_point2(1)], 'YData', [end_point2(2) rotor_end_point2(2)], 'ZData', [end_point2(3) rotor_end_point2(3)], 'visible','on');
set(obj.z_rotor3_fig,'Parent',obj.world_axes_handle,'XData',[end_point3(1) rotor_end_point3(1)], 'YData', [end_point3(2) rotor_end_point3(2)], 'ZData', [end_point3(3) rotor_end_point3(3)], 'visible','on');
set(obj.z_rotor4_fig,'Parent',obj.world_axes_handle,'XData',[end_point4(1) rotor_end_point4(1)], 'YData', [end_point4(2) rotor_end_point4(2)], 'ZData', [end_point4(3) rotor_end_point4(3)], 'visible','on');
set(obj.z_rotor5_fig,'Parent',obj.world_axes_handle,'XData',[end_point5(1) rotor_end_point5(1)], 'YData', [end_point5(2) rotor_end_point5(2)], 'ZData', [end_point5(3) rotor_end_point5(3)], 'visible','on');
set(obj.z_rotor6_fig,'Parent',obj.world_axes_handle,'XData',[end_point6(1) rotor_end_point6(1)], 'YData', [end_point6(2) rotor_end_point6(2)], 'ZData', [end_point6(3) rotor_end_point6(3)], 'visible','on');

% Update arm
end_point1 = R *Rt * obj.arm_link_body.joint1(1:3,1) + t;
end_point2 = R *Rt * obj.arm_link_body.joint2(1:3,1) + t;
end_point3 = R *Rt * obj.arm_link_body.joint3(1:3,1) + t;
end_point4 = R *Rt * obj.arm_link_body.joint4(1:3,1) + t;
end_point5 = R *Rt * obj.arm_link_body.joint5(1:3,1) + t;

set(obj.arm_link1,'Parent',obj.world_axes_handle,'XData',[t(1) end_point1(1)], 'YData', [t(2) end_point1(2)], 'ZData', [t(3) end_point1(3)], 'visible','on');
set(obj.arm_link2,'Parent',obj.world_axes_handle,'XData',[end_point1(1) end_point2(1)], 'YData', [end_point1(2) end_point2(2)], 'ZData', [end_point1(3) end_point2(3)], 'visible','on');
set(obj.arm_link3,'Parent',obj.world_axes_handle,'XData',[end_point2(1) end_point3(1)], 'YData', [end_point2(2) end_point3(2)], 'ZData', [end_point2(3) end_point3(3)], 'visible','on');
set(obj.arm_link4,'Parent',obj.world_axes_handle,'XData',[end_point1(1) end_point4(1)], 'YData', [end_point1(2) end_point4(2)], 'ZData', [end_point1(3) end_point4(3)], 'visible','on');
set(obj.arm_link5,'Parent',obj.world_axes_handle,'XData',[end_point3(1) end_point5(1)], 'YData', [end_point3(2) end_point5(2)], 'ZData', [end_point3(3) end_point5(3)], 'visible','on');

% Update the body frame
end_point1 = R * obj.x_axis_body + t;
end_point2 = R * obj.y_axis_body + t;
end_point3 = R * obj.z_axis_body + t;

% set(obj.x_axis,'Parent',obj.world_axes_handle,'XData',[t(1) end_point1(1)], 'YData', [t(2) end_point1(2)], 'ZData', [t(3) end_point1(3)], 'visible','on');
% set(obj.y_axis,'Parent',obj.world_axes_handle,'XData',[t(1) end_point2(1)], 'YData', [t(2) end_point2(2)], 'ZData', [t(3) end_point2(3)], 'visible','on');
% set(obj.z_axis,'Parent',obj.world_axes_handle,'XData',[t(1) end_point3(1)], 'YData', [t(2) end_point3(2)], 'ZData', [t(3) end_point3(3)], 'visible','on');

end