function [alphaPortPressure, dynamicPressure, AOA_grid] = makeLookupTable()
    [caliMultiple, caliOffset] = calibrate(0);
    SENSOR1_CALIBRATION_MULTIPLE = caliMultiple(1);
    SENSOR1_CALIBRATION_OFFSET = caliOffset(1);
    SENSOR3_CALIBRATION_MULTIPLE = caliMultiple(2);
    SENSOR4_CALIBRATION_MULTIPLE = caliMultiple(3);
    
    sensor1Correction = @(p) (p + SENSOR1_CALIBRATION_OFFSET).*SENSOR1_CALIBRATION_MULTIPLE;
    sensor3Correction = @(p) p.*SENSOR3_CALIBRATION_MULTIPLE;
    sensor4Correction = @(p) p.*SENSOR4_CALIBRATION_MULTIPLE;
    
    AOA = [0, 10, 20, 30, 40];
    setSpeed = [0 20 25 30 35];
    jointArray = parse();
    
    for i = 1:5
        for j = 1:5
            fileName = ['deg', num2str(AOA(i)), '_aspd', num2str(setSpeed(j)), '.mat'];
            in = load(fileName);
            p1_datCorrected = sensor1Correction(in.p1_dat(:, 2));
            p3_datCorrected = sensor3Correction(in.p3_dat(:, 2));
            alphaPortPressure(i, j) = mean(p1_datCorrected);
            %dynamicPressure(i, j) = mean(p3_datCorrected);
            dynamicPressure(i, j) = 1/2*1.14*setSpeed(j)^2;
        end
    end
    
    AOA_grid = ndgrid(AOA, setSpeed);
end