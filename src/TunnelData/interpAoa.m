function [Table_AOA] = interpAoa(arduino_alphaPortPressure, arduino_dynamicPressure)
    load("LookupTable.mat", "AOA_grid", "alphaPortPressure", "dynamicPressure");
    
    % Fit a surface to the data
    surfacefit = fit([alphaPortPressure(:), dynamicPressure(:)], AOA_grid(:),'poly22','normalize', 'on');
    Table_AOA = surfacefit(arduino_alphaPortPressure,arduino_dynamicPressure);

    % To visualize the surface, uncomment the following lines
     % figure;
     % plot(sf, [alphaPortPressure(:), dynamicPressure(:)], AOA_grid(:));
     % xlabel('alphaPortPressure');
     % ylabel('dynamicPressure');
     % zlabel('AOA');
     % title('Surface Fit');
end
