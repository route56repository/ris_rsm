function varargout = channel_obs(varargin)
%CHANNEL_OBS The channel if the are obstacles between TX and RX
%   If obstacle between BS-UE, the direct channel suffers a 30dB
%   attenuation
coord_obs = varargin{1};
cen_obs = varargin{2};
coord_tx = varargin{3};
coord_rx = varargin{4};
Hbu_og = varargin{5};
Hbu = Hbu_og;

% Normal line to obstacle '-' = [0,+/-1]
% Normal line to obstacle '|' = [+/-1,0]

% FOR EACH OBSTACLE

for o = 1:size(coord_obs,2)
    obs_l = coord_obs{o}(1,:);
    obs_r = coord_obs{o}(2,:);
    % Normal line -> 
    n = cen_obs(o,:) - coord_tx(1,1:2);
    % Vector given 1st BS coordinate and Obs. 1-st coordinate
    p = [coord_tx(1,1)-obs_l(1),coord_tx(1,2)-obs_l(2)];
    % Vector given 1st BS coordinate and Obs. 2-nd coordinate
    p2 = [coord_tx(1,1)-obs_r(1),coord_tx(1,2)-obs_r(2)];
    % First Angle of incidence to the k-th UE
    ang_inc = acosd(dot(p,n)/(norm(p)*norm(n)));
    % Second angle of incidence to the k-th UE
    ang_inc2 = acosd(dot(p2,n)/(norm(p2)*norm(n)));
    % For each UE
    for k = 1:size(coord_rx,1)
        % Vector given between the k-th UE coordinate and the BS
        d = [coord_tx(1,1)-coord_rx(k,1),coord_tx(1,2)-coord_rx(k,2)];
        % Observation angle between the BS and the obstacles
        ang_obs = acosd(dot(d,n)/norm(d)/norm(n));
        % COMPROVAR
        if(ang_inc<ang_obs && norm(n) < norm(d))
            Hbu(k,:) = Hbu_og(k,:)*(10^-1.0); % 15dB attenuation
        elseif(ang_inc2<ang_obs && norm(n) < norm(d)) %%  && norm(n) < norm(d)
            Hbu(k,:) = Hbu_og(k,:)*(10^-1.0); % 15dB attenuation
        end
    end
end
varargout = {Hbu};
end
