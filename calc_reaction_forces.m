function [A, B] = calc_reaction_forces(dA, dmid, dB, F_H, F_S)
% compute the reaction forces at points A and B
    % dA is the shaft diameter between point A and the helical gear
    % dmid is the shaft diameter between the two gears
    % dB is the shaft diameter between the spur gear and point B
    % F_H is the force on the helical gear
    % F_S is the force on the spur gear
    
    w_H = 6.3*9.81;  % weight of helical gear
    w_S = 12.6*9.81; % weight of spur gear
    rho = 7870; % density of shaft in kg/m^3

    %% Determine COM of shaft
    x = (0.1125*0.225*pi*(dA^2)/4 + 0.325*0.3875*pi*(dmid^2)/4 + 0.15*0.625*pi*(dB^2)/4)/ ...
        (0.225*pi*(dA^2)/4 + 0.325*pi*(dmid^2)/4 + 0.15*pi*(dB^2)/4);
    
    %% Determine Weight of Shaft
    w_shaft = rho*(0.225*pi*(dA^2)/4 + 0.325*pi*(dmid^2)/4 + 0.15*pi*(dB^2)/4);

    %% Determine radii of gears
    r_H = 660/6600;
    r_S = 660/3300;

    %% Determine reaction forces at A and B
    Ax = 0; % A is not locating bearing

    % Find Ay: Balance z-moments about B
    Ay = ((1200+w_S)*0.125 + (6600+w_H)*0.525 + (0.7-x)*w_shaft)/0.700;

    % Find Az: Balance y-moments about B
    Az = (3300*0.125 + 2400*0.525)/0.700;

    A = [Ax Ay Az];

    Bx = -900;  % B is locating bearing

    % Find By: Balance z-moments about A
    By = ((1200+w_S)*0.575 + (6600+w_H)*0.175 + (0.7-x)*w_shaft)/0.700;

    % Find Bz: Balance y-moments about A
    Bz = (3300*0.575 + 2400*0.175 + F_H(1)*r_H)/0.700;

    B = [Bx By Bz];

end


