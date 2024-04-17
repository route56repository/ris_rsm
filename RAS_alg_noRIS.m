function varargout = RAS_alg_noRIS(H,Na)
%Ha = RAS_alg_noRIS(H) Computes RAS algorithm with no RIS-aided channel H
%and returns the channel Ha with 2 active antennas at the RX
%[Ha,ARA] = RAS_alg_noRIS(H) Returns Ha and the index of the selected antennas

M = size(H,2); % Nº of BS antennas
N = size(H,1); % Nº of UE antennas

Ha = [];

V = ones(1,N); % All receving antennas on
X = diag(V);
Y = X;
while sum(V)>Na % While the number of active receiving antennas is > Na do:
    l = inf*ones(1,N);
    for idx = 1:N
        if V(idx) == 1              % We only try active antennas
            X(idx,idx) = 0;
            lambda = svd(H'*X*H);
            l(idx) = sum(1./lambda(1:min(M,Na))); 
            X = Y;
        end
    end
    [m,pos] = min(l);
    V(pos(1))=0;
    X = diag(V);
    Y = X;
end

% Turn off the antenas at V position
Ha = H(V==1,:);
AntSel = find(V==1);
if nargout == 0
    disp(['Selected antennas = ', num2str(V)]);
else
    varargout = {Ha,AntSel};
end
end
