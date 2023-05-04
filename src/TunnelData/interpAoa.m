function [Table_AOA] = interpAoa(arduino_alphaPortPressure, arduino_dynamicPressure)
    load("LookupTable.mat", "AOA_grid", "alphaPortPressure", "dynamicPressure");
    
    % Expand
    AOA_grid = [AOA_grid; -AOA_grid];
    alphaPortPressure = [alphaPortPressure; -alphaPortPressure];
    dynamicPressure = [dynamicPressure; dynamicPressure];

    % Fit a surface to the data
    if ~isfile("surfacefit.mat")
        surfacefit = fit([alphaPortPressure(:), dynamicPressure(:)], AOA_grid(:), ...
            'cubicinterp', ...
            ExtrapolationMethod='linear');
        save("surfacefit.mat", "surfacefit");
    else    
        load("surfacefit.mat", "surfacefit");
    end
    Table_AOA = surfacefit(arduino_alphaPortPressure,arduino_dynamicPressure);
%     if isnan(Table_AOA)
%         Table_AOA = 0;
%     end

    % To visualize the surface, uncomment the following lines
     figure;
     plot(surfacefit, [alphaPortPressure(:), dynamicPressure(:)], AOA_grid(:));
     xlabel('alphaPortPressure');
     ylabel('dynamicPressure');
     zlabel('AOA');
     title('Surface Fit');
end
