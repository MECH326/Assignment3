function [passed,criticalSpeed] = CriticalSpeed(dA,dmid,dB,safetyFactor)
    % constants
    operating_w = 1200 % rad/s
    E = 184E9; %PA
    rho = 7870; %kg/m^3
    
    sum = 0; % keeping track of the sum of all the frequencies
    cells = 140; 
    length = 0.7; 
    cellLength = length/cells; 
    
    for i = 1:140
        test = i;
        % going through and calculating
        x_i = cellLength* (test-0.5); % mid point of each cell
        I = I_i(test, dA, dmid, dB);
        m_i = W_i(test,rho,dA,dmid,dB)/9.81; %convert  to mass
        mDelta = m_i*x_i^2*(length-x_i)/(3*E*I);
        sum = sum + mDelta;
    end 
    criticalFrequency = sqrt(1/sum);
    criticalSpeed = criticalFrequency/(2*pi())*60;
    if criticalSpeed >= safetyFactor*operating_w
        passed = true;  
    else 
        passed = false; 
    end 
end 

% compute the weights of various cross sections as you go across the beam
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
    weight = mass*9.81; %if its zero, something is wrong
    % should be in Netwons 
end

function polarM = I_i(i,dA,dmid,dB)
   [I,J] = compute_moments(dA,dmid,dB);
   polarM = 0;
   if i <= 45
       polarM = I(1);
   elseif ( 46<= i && i<= 110)
       polarM = I(2);
   elseif 140>= i
       polarM = I(3);
   end 
end 

% density: http://www.matweb.com/search/DataSheet.aspx?MatGUID=10b74ebc27344380ab16b1b69f1cffbb&ckck=1