function [RIS_i,ang_RIS] = RIS_parameters(RIS,loc,m)
%[RIS_i,ang_RIS,NRIS] = RIS_parameters(RIS,loc) Return the RIS parameters
%depending on the number of RISs and the scenario in case we have 1 RIS. It
%returns: RIS_i: cell with 1st RIS element location
%         ang_RIS: cell with RIS orientation angles
% INPUT PARAMETERS:
%   RIS: Nº of RISs
%   loc: 1 for Scenario 2,4
%        2 for Scenario 1,3

switch(RIS)
    case 1
        switch(loc)
            case 1 % Scenario 1,3
                RIS_i{1} = [0,m/2,6];                   % 1st element location
                ang_RIS{1} = [pi/2,0];                  % RIS orientation
            case 2 % Scenario 2,4
                RIS_i{1} = [m/2,0,6];                   % 1st element location
                ang_RIS{1} = [pi/2,pi/2];               % RIS orientation
            case 3 % Scenario 2,4
                RIS_i{1} = [0,m/2,6];                   % 1st element location
                ang_RIS{1} = [pi/2,pi/2];               % RIS orientation
        end

    case 2
        switch(loc)
            case 0
                % 1st elements location
                RIS_i{1} = [0,m/2-5,6];
                RIS_i{2} = [0,m/2+5,6];
                % Orientation angles
                ang_RIS{1} = [pi/2,0];
                ang_RIS{2} = [pi/2,0];
            case 1
                % 1st elements location
                RIS_i{1} = [0,m/2,6];
                RIS_i{2} = [m,m/2,6];
                % Orientation angles
                ang_RIS{1} = [pi/2,0];
                ang_RIS{2} = [pi/2,pi];
            otherwise
                % 1st elements location
                RIS_i{1} = [0,50,6];
                RIS_i{2} = [100,50,6];
                % Orientation angles
                ang_RIS{1} = [pi/2,0];
                ang_RIS{2} = [pi/2,pi];
        end
    case 3
        % 1st elements location
        RIS_i{1} = [0,24,6];
        RIS_i{2} = [0,25,6];
        RIS_i{3} = [0,26,6];
        % Orientation angles
        ang_RIS{1} = [pi/2,0];
        ang_RIS{2} = [pi/2,0];
        ang_RIS{3} = [pi/2,0];
end