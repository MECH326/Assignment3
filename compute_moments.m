function [I, J] = compute_moments(dA, dmid, dB)
% find the moment of inertia (I) and polar moment of area (J) for the shaft
% I and J are row vectors with 3 elements, corresponding to the three sections of shaft:
  % dA is the shaft diameter between between point A and helical gear
  % dmid is the shaft diameter between the two gears
  % dB is the shaft diameter between the spur gear and point B

  rho = 7870; % density of 1020cd steel in kg/m^3

  MA = rho*pi*(dA^2)/4;
  Mmid = rho*pi*(dmid^2)/4;
  MB = rho*pi*(dB^2)/4;

  I = [MA*((dA/2)^2)/4, Mmid*((dmid/2)^2)/4, MB*((dB/2)^2)/4];
  J = [pi*((dA/2)^4)/2, pi*((dmid/2)^4)/2, pi*((dB/2)^4)/2];
end

