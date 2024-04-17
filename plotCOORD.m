function lg = plotCOORD(varargin)
%plotCOORD 
% Plot the top view simulation setup
angBS = varargin{1};
angUE = varargin{2};
ang_RIS = varargin{3};
BS = varargin{4};
UE = varargin{5};
RIS_i = varargin{6};

if(iscell(RIS_i))
    RISmat = cell2mat(RIS_i.');
    RIS = size(RISmat,1);
else
    RISmat = RIS_i;
    RIS = size(RISmat,1);
end
for p = 1:RIS
    if(abs(ang_RIS{p}(2)) == pi/2)
        markerR = "_";
    else
        markerR = "|";
    end
    scatter(RISmat(p,1),RISmat(p,2),100,'magenta',markerR,'LineWidth',2,'DisplayName',['RIS ',num2str(p)]);
    hold on;
end
if(abs(angBS(2)) == pi/2)
    markerT = "_";
else
    markerT = "|";
end
scatter(BS(:,1),BS(:,2), 100,'r',markerT,'LineWidth',2,'DisplayName','BS');

xlabel('x [m]');
ylabel('y [m]');

if nargin>6
    if varargin{7} == 0
        % Plot the obstacles (Scenario 4)
        % Coordinates of obstacle 1 and obstacle 2
        obstacle1 = [[45,25];[55,25]];
        obstacle2 = [[25,45];[25,55]];
        plot(obstacle1(:,1),obstacle1(:,2),'k','LineWidth',3,'DisplayName','Obs. 1');
        plot(obstacle2(:,1),obstacle2(:,2),'k','LineWidth',3,'DisplayName','Obs. 2');
    else
        % Plot the UE (Scenario 1,3)
        if(angUE(2) == pi/2)
            markerRx = "_";
        else
            markerRx = "|";
        end
        scatter(UE(:,1),UE(:,2), 60,'b',markerRx,'LineWidth',2,'DisplayName','UE');
    end
end
lg = legend;
lg.NumColumns = 1;

xlim([0,80]);
ylim([0,80]);
end