% CREATES A MAP WITH DIFFERENT INFORMATION
% We measure an m mxm (m^2) area every n meters. We compute the
% information for an RSM transmission
folderTest = [folderRIS,'\',strTest];
abcd = 'abcdefghijklmnopqrstuvwxyz';

k=0;
for yi = 0:n:(m-n)
    numTest = 1; %For each x [0-20,20-40,...]-[a,b,c...]
    ymin = yi;
    ymax = ymin + n;
    y = ymin:n/10:(ymax-n/10);
    for xi = 0:n:(m-n)
        xmin = xi;
        xmax = xmin + n;
        x = xmin:n/10:(xmax-n/10);
        nameTest = abcd(numTest);
        file_test =['MIMO',num2str(Mtx),num2str(Nrx),'_',nameTest,num2str(k),'.mat'];
        completename = [folderTest,'\',file_test];
%         if exist(completename,'file')
%             disp('FILE ALREADY EXISTS !!')
%         else
            for a = 1:size(x,2)
                x_i = x(a);
                % Calculate all information for a fixed x_i coordinate and multiple
                % y coordinates
                INFO = mapCellRSM(BS,RIS_i,Ny,x_i,y,Mtx,Nrx,Na,angBS,angUE,ang_RIS);
                disp([num2str(a) '/' num2str(size(x,2)), ' OK']);
                % Save information in different matrices
                al_bu(a,:) = INFO{1};
                al(a,:) = INFO{2};
                al_coef1(a,:) = INFO{3};

            end
            % Save the matrices in a mat file
            save([folderTest,'\',file_test],"al_bu","al","al_coef1","-append");
        % end
        numTest = numTest + 1;
    end
    k = k+1;
    disp([num2str(yi), ' DONE !!!']);
end