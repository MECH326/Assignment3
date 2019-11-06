function passed = criticalSpeedCheck(dA,dmid,dB,safetyFactor)
    % constants
    operating_w = 1200*2*pi/60; % rad/s
    E = 184E9; %PA
    rho = 7870; %kg/m^3

    passed = true;
end 

function weight = W_i(i,rho,dA,dmid,dB)
    mass = 0;
    cellLength = 5/1000; %m
    massDistSpurGear = 252; %kg/m
    massDistHelicalGear = 63; %kg/m
    if i <= 25
        mass = cellLength* pi*(dA/2)^2*rho;
    elseif (26<= i && i <= 45)
        mass = cellLength* (pi*(dA/2)^2*rho+ massDistHelicalGear);
    elseif (46<= i && i <= 110)
        mass = cellLength*(pi*(dmid/2)^2);
    elseif (111<= i && i <= 120)
        mass = cellLength*(pi*(dB/2)^2 + massDistSpurGear);
    elseif (121<= i && i <= 140)
        mass = cellLength*(pi*(dB/2)^2);
    else
        %nothign, if it gets to here something is wrong
    end 
    weight = mass *9.81; %if its zero, something is wrong
    % should be in Netwons 
end

function polarM = I_i(i,d1,d2,d3)
   
end 

% density: http://www.matweb.com/search/DataSheet.aspx?MatGUID=10b74ebc27344380ab16b1b69f1cffbb&ckck=1