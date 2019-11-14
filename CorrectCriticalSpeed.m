
%main function that is used to evaulate if the part passes in speed
function [passed,criticalSpeed] = CorrectCriticalSpeed(dA,dmid,dB,safetyFactor)
    operatingCondition = 1200*2*pi/60;
    passed = deflectionAtX(dA,dmid,dB,0.7);
    criticalSpeed =1;
end 

% passes on a list of known distance values
function [d_AtoM1, d_AtoM2,d_AtoM3,d_AtoM4,d_AtoM5,d_AtoC,d_AtoD] = populateDistances()
    % distances 
    d_AtoM1 = 0.125/2;
    d_AtoM2 = 0.125+0.1/2;
    d_AtoM3 = 0.225 + 0.325/2; 
    d_AtoM4 = 0.225+0.325 + 0.05/2;
    d_AtoM5 = 0.225+ 0.325 + 0.05 + 0.1/2;
    d_AtoC = 0.225; 
    d_AtoD = 0.225+0.325;
end 

%passes on a list of known lengths
function [L_M1,L_M2,L_M3,L_M4,L_M5,totalLength] = populateLengths()
    %lengths
    L_M1 = 0.125; 
    L_M2 = 0.1; 
    L_M3 = 0.325; 
    L_M4 = 0.05; 
    L_M5 = 0.1;
    totalLength = 0.7;

end 
%computes the various forces due to masses
function [F_A, F_g1, F_g2,F_g3, F_g4, F_g5, F_B] = weightsBalance(dA,dmid,dB)
    g = 9.81; %N/kg
    rho = 7870; %kg/m^3
    [d_AtoM1, d_AtoM2,d_AtoM3,d_AtoM4,d_AtoM5,d_AtoC,d_AtoD] = populateDistances();
    [L_M1,L_M2,L_M3,L_M4,L_M5,totalLength] = populateLengths();
    
    %calculating known weights
    F_g1 = g*pi()*(dA/2)^2*L_M1*rho;
    F_g2 = ( (dA/2)^2*L_M2*pi()*rho + 6.3)*g;
    F_g3 = (dmid/2)^2*L_M3*g*pi()*rho;
    F_g4 = ( (dB/2)^2*L_M4*pi()*rho + 12.6 )*g;
    F_g5 = (dB/2)^2*L_M5*pi()*g*rho; 
    
    %solving the moment balance and force balance
    F_B = 1/totalLength*( F_g1*d_AtoM1 + F_g2*d_AtoM2 + F_g3*d_AtoM3 + F_g4*d_AtoM4 + F_g5*d_AtoM5);
    F_A = F_g1 + F_g2 + F_g3 + F_g4 +F_g5 - F_B;

end 

%computes the deflection due to each mass contribution. 
function [ deflection_A,deflection_Mass1,deflection_Mass2,deflection_Mass3,deflection_Mass4,deflection_Mass5,deflection_JumpC,deflection_JumpD] = singularityStages(dA, dmid, dB,x)
    %collecting the constants that are known
    [d_AtoM1, d_AtoM2,d_AtoM3,d_AtoM4,d_AtoM5,d_AtoC,d_AtoD] = populateDistances();
    %other calculated constants
    [I,J] = compute_moments(dA,dmid,dB);
    I_1 = I(1);
    I_2 = I(2);
    I_3 = I(3);
    [F_A, F_g1, F_g2,F_g3, F_g4, F_g5, F_B] = weightsBalance(dA,dmid,dB); 
    M_c = F_A*d_AtoC -1*F_g1*(d_AtoC-d_AtoM1) -1*F_g2*(d_AtoC-d_AtoM2);
    M_d = F_A*d_AtoD -1*F_g1*(d_AtoD-d_AtoM1) -1*F_g2*(d_AtoD-d_AtoM2) - 1*F_g3 *(d_AtoD-d_AtoM3);
    
    %calculating all the possible stages of the singularity functions
    deflection_A = F_A/(6*I_1)*x^3;
    deflection_Mass1 = -1*F_g1/(6*I_1)*(x-d_AtoM1)^3;
    deflection_Mass2 = -1*F_g2/(6*I_1)*(x-d_AtoM2)^3;
    deflection_JumpC = -M_c/2 * (1/I_1-1/I_2)* (x-d_AtoC)^2;
    deflection_Mass3 = -1*F_g3/(6*I_2)*(x-d_AtoM3)^3;
    deflection_JumpD = -M_d/2*(1/I_2 - 1/I_3)*(x-d_AtoD)^2;
    deflection_Mass4 = -1*F_g4/(6*I_3)*(x-d_AtoM4)^3;
    deflection_Mass5 = -1*F_g5/(6*I_3)*(x-d_AtoM5)^3;
  
end 

% computes the final deflection at a x-coordinate
function deflectionTotal = deflectionAtX(dA, dmid, dB,x)

    %known constants
    totalLength = 0.7;
    E = 184E9;
    [d_AtoM1, d_AtoM2,d_AtoM3,d_AtoM4,d_AtoM5,d_AtoC,d_AtoD] = populateDistances();
    
    
    %solving unkown coefficient
    [deflectionA1,dMass1,dMass2,dMass3,dMass4,dMass5,dJumpC,dJumpD] = singularityStages(dA, dmid, dB,totalLength);
    [deflection_A,deflection_Mass1,deflection_Mass2,deflection_Mass3,deflection_Mass4,deflection_Mass5,deflection_JumpC,deflection_JumpD] = singularityStages(dA, dmid, dB,x);
    c_1 = -1*1/totalLength*(deflectionA1+dMass1+dMass2+dMass3+dMass4+dMass5+dJumpC+dJumpD);
   
   
    %simulating the effects of the various singularity functions
    if(x <= d_AtoM1)
        deflectionTotal = deflection_A + c_1*x; 
    elseif (x>d_AtoM1 && x<= d_AtoM2)
        deflectionTotal = deflection_A+ deflection_Mass1+ c_1*x; 
    elseif( x>d_AtoM2 && x<=d_AtoC)
        deflectionTotal = deflection_A  + deflection_Mass1 + deflection_Mass2+ c_1*x; 
    elseif (x>d_AtoC &&  x<= d_AtoM3)
        deflectionTotal = deflection_A  + deflection_Mass1 + deflection_Mass2+ deflection_JumpC+ c_1*x; 
    elseif (x>d_AtoM3 &&  x<= d_AtoD)
        deflectionTotal = deflection_A  + deflection_Mass1 + deflection_Mass2+ deflection_Mass3+ c_1*x;
    elseif (x>d_AtoD &&  x<= d_AtoM4)
        deflectionTotal = deflection_A  + deflection_Mass1 + deflection_Mass2+ deflection_Mass3+ deflection_JumpD+ c_1*x;
    elseif (x>d_AtoM4 && x<= d_AtoM5)
        deflectionTotal = deflection_A  + deflection_Mass1 + deflection_Mass2+ deflection_Mass3+ deflection_JumpD+ deflection_Mass4+ c_1*x;
    elseif (x>d_AtoM4 &&  x<= totalLength)
        deflectionTotal = deflection_A  + deflection_Mass1 + deflection_Mass2+ deflection_Mass3+ deflection_JumpD+ deflection_Mass4+ deflection_Mass5+c_1*x
    end 
    deflectionTotal = 1/E* deflectionTotal;

end 
