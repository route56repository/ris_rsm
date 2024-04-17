function coord_ris = COORD_RIS(RIS_i,Nz,Ny,lam,ang_RIS)
%COORD_RIS(RIS_i,Nz,Ny,lam,ang_RIS) creates all the coordinates of
%the elements at the RIS.
%   RIS_i: 1st element location at the RIS
%   Nz: Nº of elements in the z-axis
%   Ny: Nº of elements in the x/y-axis
%       The total number of RIS elements Nr=Nz*Ny
%   lam: Carrier freqeucny in wavelenght (m)
%   ang_RIS: Orientation angles of RIS

xr = RIS_i(1);
yr = RIS_i(2);
zr = RIS_i(3);

dist_el = 0.25;         % Elements spacing at the RIS
phi_RIS = ang_RIS(2);   % Azimuth angle of RIS

% RIS COORDINATES according to eq(3.3)
for n = 1:Nz
    for m = 1:Ny
        r = (m-1)*Nz+n;
        coord_ris(r,:) = [xr,yr,zr]+[(m-1)*sin(phi_RIS),(m-1)*cos(phi_RIS),(n-1)]*dist_el*lam;
    end
end

end