% Return the desired path corners in terms of waypoints

function waypoints = choose_waypoints()

waypoints = [0,0,-2; ... % Initial position to takeoff
             0,-2,-2; ...
             -2,-2,-2; ...
             -2,0,-2; ...
             0,0,-2];    % Final position
% waypoints = [0 0 -2];
end