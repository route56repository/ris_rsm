function lg = TopView(varargin)
%TOPVIEW Provides a TopView of the Scenario. BS and RIS fixed locations
BS = varargin{1};
angBS = varargin{2};
RIS_i = varargin{3};
ang_RIS = varargin{4};

if nargin > 4
    obstacle = varargin{5};
    m = varargin{6};
else
    m=80;
end

LegendTags = {};
if ~isnan(RIS_i)
if(iscell(RIS_i))
    RISmat = cell2mat(RIS_i.');  
else
    RISmat = RIS_i;
end
RIS = size(RISmat,1);
% PLOT RIS
for p = 1:RIS
    if(abs(ang_RIS{p}(2)) == pi/2)
        markerR = "_";
    else
        markerR = "|";
    end
    % scatter(RISmat(p,1),RISmat(p,2),100,'magenta',markerR,'LineWidth',3,'DisplayName',['RIS ',num2str(p)]);
    scatter(RISmat(p,1),RISmat(p,2),200,'magenta',markerR,'LineWidth',4);
    LegendTags(end+1) = {'RIS'};
    hold on;
end
end
%PLOT BS
if(abs(angBS(2)) == pi/2)
    markerT = "_";
else
    markerT = "|";
end
scatter(BS(:,1),BS(:,2), 200,'r',markerT,'LineWidth',4);
LegendTags(end+1) = {'BS'};
xlabel('x [m]');
ylabel('y [m]');

if nargin > 4
    % Plot the obstacles
    for oo = 1:obstacle{3}
        obs = obstacle{1}{oo};
        plot(obs(:,1),obs(:,2),'k','LineWidth',4);
    end
    LegendTags(end+1) = {'Obstacle'};
end
lg = legend(LegendTags);
lg.NumColumns = 1;
lg.Interpreter = 'latex';
lg.Location = 'best';
xlim([0,m]);
ylim([0,m]);
end

