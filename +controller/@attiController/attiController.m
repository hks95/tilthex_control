classdef attiController < handle

    properties

        Kr              % 3x3 matrix, gain for the error of attitude
        Kw              % 3x3 matrix, gain for the error of angular velocity

        freq            % scalar, the frequency at which the attitude controller runs
        max_torque      % scalar, the maximum torque that can be provided

    end

    methods

        % Class constructor
        function obj = attiController( control_settings )

            obj.Kr = control_settings.Kr;
            obj.Kw = control_settings.Kw;

            obj.freq       = control_settings.freq;
            obj.max_torque = control_settings.max_torque;

        end

        % Interface of the class
        [] = control(obj, src, event_data)


        % Find the shortest distance between two angles
        function diff = shortestAngle(obj, ang1, ang2)

            raw_diff     = ang1 - ang2;
            num_of_2pis  = fix(raw_diff / (2*pi));
            cropped_diff = raw_diff - 2*pi*num_of_2pis;
            comp_diff    = 2*pi - cropped_diff;

            if abs(cropped_diff) > abs(comp_diff)
                diff = comp_diff;
            else
                diff = cropped_diff;
            end

        end

        % Destructor of the class
        function [] = delete(obj)

        end

    end

end

