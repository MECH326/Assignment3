function [I, J] = compute_moments(dA, dmid, dB)
% find the  area moment of inertia (I) and polar moment of area (J) for the shaft
% I and J are row vectors with 3 elements, corresponding to the three sections of shaft:
  % dA is the shaft diameter between between point A and helical gear
  % dmid is the shaft diameter between the two gears
  % dB is the shaft diameter between the spur gear and point B

  MA = pi*(dA^2)/4;
  Mmid = pi*(dmid^2)/4;
  MB = pi*(dB^2)/4;

  I = [MA*((dA/2)^2)/4, Mmid*((dmid/2)^2)/4, MB*((dB/2)^2)/4];
  J = [pi*((dA/2)^4)/2, pi*((dmid/2)^4)/2, pi*((dB/2)^4)/2];
end

