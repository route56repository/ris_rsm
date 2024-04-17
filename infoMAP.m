function c = infoMAP(varargin)
% Configures the map plots for Scenario 2 and Scenario 4
tl = varargin{1};       % Figure title
if(nargin>1)
    lims=varargin{2};   % Colorbar limits
    if lims == 0
        lims ='auto';
    end
else
    lims='auto';
end
colormap("turbo");
c = colorbar;
xlabel('x (m)','Interpreter','latex');
ylabel('y (m)','Interpreter','latex');
title(tl);
xlim auto
ylim auto
clim(lims)
end