classdef posController < handle

    properties

        Kp           % 3x3 matrix, gain for the error of position
        Kd           % 3x3 matrix, gain for the error of linear velocity

        mass         % scalar, mass of the quadrotor

        freq         % scalar, the frequency of the controller
        max_thrust % scalar, the maximum thrust that can be provided

    end

    methods

        % Class Constructor
        function obj = posController( contrl_settings )

            obj.Kp = contrl_settings.Kp;
            obj.Kd = contrl_settings.Kd;
            obj.mass = contrl_settings.mass;
            obj.freq = contrl_settings.freq;           
            obj.max_thrust = contrl_settings.max_thrust;

        end

        % Interface of the algorithm
        [] = control(obj, src, event_data)

        % Class destructor
        function [] = delete(obj)

        end

    end

end



