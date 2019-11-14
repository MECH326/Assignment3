

%uniform beam test using beam tables
totalLength = 0.7; 
radius = 0.1/2; 

[test, criticalSpeed] = CorrectCriticalSpeed(radius*2,radius*2,radius*2,3)
[test2, criticalSpeed2] = CriticalSpeed(radius*2,radius*2,radius*2,3)
E = 184E9;
rho = 7870; %kg/m^3;
mass_Beam = radius^2 *totalLength*rho;
[I,J] = compute_moments(radius*2,radius*2,radius*2);
shaftFrequency = 9.87/totalLength^2*sqrt(E*I(1) /mass_Beam);
frequency_spurGear = 1.73*sqrt( (E*I(1)*totalLength ) / ( 12.6*0.575^2*0.125^2 ));
frequency_HelicalGear = 1.73*sqrt( (E*I(1)*totalLength ) / ( 6.3*0.175^2*0.525^2 ));

criticalFrequency = 1/sqrt(1/shaftFrequency^2 + 1/frequency_spurGear^2 + 1/frequency_HelicalGear^2);
criticalSpeed3 = criticalFrequency/(2*pi())*60
