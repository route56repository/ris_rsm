% CREATES A MAP WITH DIFFERENT INFORMATION
% We measure an 100mx100m area. We compute the information for each type
% of transmission RSM or TxBF every 2mx2m

n = 10;
m = 100;
for yi = 0:n:(m-n)
    ymin = yi;
    ymax = ymin + n;
    for xi = 0:n:(m-n)
        xmin = xi;
        xmax = xmin + n;
        x = linspace(xmin,xmax,n);
        y = linspace(ymin,ymax,n);
        for a = 1:size(x,2)
            x_i = x(a);
            % Calculate all information for a fixed x_i coordinate and multiple
            % y coordinates
            INFO = mapINFO(BS,RIS_i,Ny,x_i,y,Mtx,Nrx,angBS,angUE,ang_RIS,mode);
            disp([num2str(a) '/' num2str(size(x,2)), ' OK']);
            % Save information in different matrices
            if(strcmp(mode,'RSM'))
                ABEP_bu(a,:) = INFO{1};
                ABEP(a,:) = INFO{2};
                ABEP_no(a,:) = INFO{3};

                al_bu(a,:) = INFO{4};
                al(a,:) = INFO{5};
                al_no(a,:) = INFO{6};

                EE_rsm_bu(a,:) = INFO{7};
                EE_rsm(a,:) = INFO{8};
            else
                CBFbu(a,:) = INFO{1};
                CBF(a,:) = INFO{2};
                CBF_no(a,:) = INFO{3};

                SE_bu(a,:) = INFO{4};
                SE_bf(a,:) = INFO{5};
                SE_no(a,:) = INFO{6};

                EE_bu(a,:) = INFO{7};
                EE_bf(a,:) = INFO{8};
                EE_no(a,:) = INFO{9};
            end
        end
        % Save the matrices in a mat file
        str =[mode,'_MIMO',num2str(Mtx),num2str(Nrx),' ',num2str(x_i),'_',num2str(min(y)),'.mat'];
        save(str);
    end

end