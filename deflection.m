function pass = deflection(dA, dmid, dB)
% Checks the deflection and slope is acceptable at the bearings and gears
    % dA is the shaft diameter between point A and the helical gear
    % dmid is the shaft diameter between the two gears
    % dB is the shaft diameter between the spur gear and point B

pass = true;
[A, ~] = calc_reaction_forces(dA, dmid, dB);
[I, ~] = compute_moments(dA, dmid, dB);

% linear density of shaft (label L)
rho = 7870; % 1020cd steel density in kg/m^3
E = 184*10^9; %Young's Modulus 1020 steel Pa
LA = 9.81*rho*pi*(dA^2)/4;
Lmid = 9.81*rho*pi*(dmid^2)/4;
LB = 9.81*rho*pi*(dB^2)/4;


% use right boundary condition to find linear term in z deflection
Cz = (-(A(3)/(6*I(1)))*(0.7)^3 + (2400/(6*I(2)))*(0.7-0.175)^3 + (3300/(6*I(3)))*(0.7-0.575)^3)/(0.7*E);

% use right boundary condition to find linear term in y deflection
Cy = (-(A(2)/(6*I(1)))*(0.7)^3 + (LA/(24*I(1)))*(0.7)^4 + (6600/(6*I(2)))*(0.7-0.175)^3 - (LA/(24*I(2)))*(0.7-0.175)^4 + ...
      (Lmid/(24*I(2)))*(0.7-0.175)^4 + (1200/(6*I(3)))*(0.7-0.575)^3 - (Lmid/(24*I(3)))*(0.7-0.575)^4 + (LB/(24*I(3)))*(0.7-0.575)^4)/(0.7*E);

%% Check Spur Gear
% deflections
    dz = ((A(3)/(6*I(1)))*(0.575)^3 - (2400/(6*I(2)))*(0.575-0.175)^3)/E + Cz*(0.575);
    dy = ((A(2)/(6*I(1)))*(0.575)^3 + (LA/(24*I(1)))*(0.575)^4 + (6600/(6*I(2)))*(0.575-0.175)^3 ...
          - (LA/(24*I(2)))*(0.575-0.175)^4 + (Lmid/(24*I(2)))*(0.575-0.175)^4)/E + Cy*(0.575);
  
    % check that total deflection is < 0.01 inch
    pass = pass && (sqrt(dz^2 + dy^2) < 0.01*100/2.54);
    disp(['spur deflect: ' num2str(sqrt(dz^2 + dy^2))])

% slope
    tz = ((A(3)/(2*I(1)))*(0.575)^2 - (2400/(2*I(2)))*(0.575-0.175)^2)/E + Cz;
    ty = ((A(2)/(2*I(1)))*(0.575)^2 - (LA/(6*I(1)))*(0.575)^3 - (6600/(2*I(2)))*(0.575-0.175)^2 ...
         + (LA/(6*I(2)))*(0.575-0.175)^3 - (Lmid/(6*I(2)))*(0.575-0.175)^3)/E + Cy;
  
    % check that total slope is < 0.0005
    pass = pass && (sqrt(tz^2 + ty^2) < 0.0005);
    disp(['spur slope: ' num2str(sqrt(tz^2 + ty^2))])

%% Check Bearings
% left bearing (point A) slope
    % check that total slope is < 0.001
    pass = pass && (sqrt(Cz^2 + Cy^2) < 0.001);
    disp(['bearing A slope: ' num2str(sqrt(Cz^2 + Cy^2))])

% right bearing (point B) slope
    tz = ((A(3)/(2*I(1)))*(0.7)^2 - (2400/(2*I(2)))*(0.7-0.175)^2 - (3300/(2*I(3)))*(0.7-0.575)^2)/E + Cz;
    ty = ((A(2)/(2*I(1)))*(0.7)^2 - (LA/(6*I(1)))*(0.7)^3 - (6600/(2*I(2)))*(0.7-0.175)^2 + (LA/(6*I(2)))*(0.7-0.175)^3 ...
         - (Lmid/(6*I(2)))*(0.7-0.175)^3 - (1200/(2*I(3)))*(0.7-0.575)^2 + (Lmid/(6*I(3)))*(0.7-0.575)^3 - (LB/(6*I(3)))*(0.7-0.575)^3)/E + Cy;
  
    % check that total slope is < 0.001
    pass = pass && (sqrt(tz^2 + ty^2) < 0.001);
    disp(['bearing B slope: ' num2str(sqrt(tz^2 + ty^2))])

end

