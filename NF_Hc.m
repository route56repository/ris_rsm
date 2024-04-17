function varargout = NF_Hc(Nz,Ny,coord_tx,coord_rx,coord_ris,ang_RIS)
%COMPUND_CHANNEL Calculates the total compound channel when RIS-aided 
%   Model in the near-field
%   freq: Carrier frequency
%   Nz: Nº RIS elements in z-axis
%   Ny: Nº RIS elements in x/y-axis
%   coord_tx: BS antenna locations
%   coord_rx: UE antenna locations
%   coord_ris: RIS element locations
%   ang_RIS: RIS orientation angles

% Antenna and RIS simulation parameters
system_parameters;
a = dist_el*lam;
b = dist_el*lam;
% psi_i: angle of arrival to the surface
% x > 0
vec_i = -coord_ris(1,:)+coord_tx(1,:);
psi_i = sign(vec_i(2))*acos(vec_i(1)/(norm(vec_i(1:2))));

% Compunch channel pathloss Eq(3.16)
pathloss_comp = 10^(Gt/10)*10^(Gr/10)/((4*pi)^2)*(a*b)^2*cos(psi_i)^2;

% When UE out of the RIS range -> RIS does not reflect
% switch(ang_RIS(2))
%     case 0 % If xu < xr
%         if(coord_rx(1,1) < coord_ris(1,1)) 
%             pathloss_comp = 0;
%         end
%     case pi % If xu > xr
%         if(coord_rx(1,1) > coord_ris(1,1))
%             pathloss_comp = 0;
%         end
%     case pi/2 % If yu > yr
%         if(coord_rx(1,2)>coord_ris(1,2))
%             pathloss_comp = 0;
%         end
%     case -pi/2 % If yu < yr
%         if(coord_rx(1,2)<coord_ris(1,2))
%             pathloss_comp = 0;
%         end
% end
M = size(coord_tx,1);
N = size(coord_rx,1);
for s = 1:M
    for m = 1:Ny
        for n = 1:Nz
        i = (m-1)*Nz + n;
        d_si = norm(coord_tx(s,:)-coord_ris(i,:));   % Distance between s^th BS antenna and i^th RIS element        
        Hbr(i,s) = exp(-1i*2*pi/lam*d_si)/d_si;
        ds1(i,s) = d_si;
        end
    end
end
for l = 1:N
    for m = 1:Ny
        for n = 1:Nz
        i = (m-1)*Nz + n;
        d_li = norm(coord_rx(l,:)-coord_ris(i,:));   % Distance between s^th BS antenna and i^th RIS element
        vec = coord_rx(l,:)-coord_ris(i,:);
        psi_s = sign(vec(2))*acos(vec(1)/(norm(vec(1:2))));%-pi/2;
        theta_s = acos(vec(3)/d_li);
        % TMz
        % a = dist_el*lam;
        % b = dist_el*lam;

        % y = pi*b/lam*(sin(psi_s)*sin(theta_s)+sin(psi_i)); %+/-
        % z = pi*a/lam*(cos(theta_s));       

        y = pi*b/lam*(sin(psi_s)+sin(psi_i));
        z = 0;
        
        sinc_y = (sin(y)/y);
        sinc_y(isnan(sinc_y)) = 1;
        sinc_z = sin(z)/z;
        sinc_z(isnan(sinc_z)) = 1;
        % E_theta = sin(theta_s)*sinc_y*sinc_z;
        E_theta = sinc_y*sinc_z;
        E_psi = 0;
        
        % % TMy
        % y = pi*b/lam*(sin(psi_s)*sin(theta_s)+sin(psi_i)); %+/-
        % z = pi*a/lam*(cos(theta_s));
        % sinc_y = (sin(y)/y)*cos(theta_s)*sin(psi_s);
        % sinc_y(isnan(sinc_y)) = 1;
        % sinc_z = sin(z)/z;
        % sinc_z(isnan(sinc_z)) = 1;
        % E_theta = cos(theta_s)*sin(psi_s)*sinc_y*sinc_z;
        % E_psi = cos(psi_s)*sinc_y*sinc_z;
        % 
        
        bb = sqrt(E_theta^2+E_psi^2);

        % bb=1;
        
        Hru(l,i) = exp(-1i*2*pi/lam*d_li)/d_li*bb;
        ds2(l,i) = d_li;
        % 
        % pathloss_comp*bb/d_li
        end
    end
end
% Compunch channel pathloss Eq(3.16)
% sqrt_path = sqrt(pathloss_comp);
varargout = {Hbr, Hru,sqrt(pathloss_comp),ds1,ds2};
end

