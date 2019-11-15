function [ Bend,compress,Tau,location,diameter] = Stresses( A,B,F1,F2,RA,Rmid,RB,p,T,M1,M2, R_H, R_S)
%Taking forces on A, A and forces on B, the gear forces F1 and F2
%   Detailed explanation goes here

%% getting moments of inertia
[I,J]=compute_moments(2*RA,2*Rmid,2*RB)
%% Finding moment at the shoulders
% Integrate shear force diagrams
M1Z= A(2)*(-.225) + (A(2) - 9.81*p*pi()*RA^2*(.225))*((-.225)/2) - (A(2)-9.81*p*pi()*RA^2*(.225)-M1*9.81+F1(2))*.05;
M1Y= A(3)*(-.225) + (A(3) + F1(3))*(-0.050) + F1(1)*R_H;

M1=sqrt(M1Z^2+M1Y^2);
sigmabend1=M1*RA/I(1);

%Integrate shear force diagrams from the other side (less terms)
M2Z=B(2)*(.150) + (B(2)-9.81*p*pi()*RB^2*.150)*(.150/2)+ (B(2)-9.81*p*pi()*RB^2*.150 - M2*9.81 + F2(2))*(.025);
M2Y=B(3)*(.150) + (B(3) + F2(3))*(.025);

M2=sqrt(M2Y^2+M2Z^2);
sigmabend2=M2*RB/I(3);

% M1Z=-A(2)*(.225)+9.81*p*pi()*RA^2*(.225)^2/2+M1*.05;
% M1Y=A(3)*(.225)+F1(3)*.05+900*.1;
% 
% M1=sqrt(M1Z^2+M1Y^2);
% sigmabend1=M1*RA/I(1);
% 
% M2Z=-A(2)*(.550)+F1(2)*.375+M1*.375+9.81*p*pi()*RA^2*.225*(.325+.225/2)+9.81*p*pi()*Rmid^2*(.325)^2/2;
% M2Y=A(3)*(.550)+F1(3)*.375+900*.1;
% 
% M2=sqrt(M2Y^2+M2Z^2);
% sigmabend2=M2*RB/I(3);


%% stress due to compression

sigmacompress1=0;
sigmacompress2=F1(1)/(pi*RB^2);


%% shear stress due to torsion
Tau1=T*RA/J(1);
Tau2=T*RB/J(3);

%% check critical location

if (sigmabend1+sigmacompress1)>(sigmabend2+sigmacompress2)
    Tau=Tau1;
    compress=sigmacompress1;
    Bend=sigmabend1;
    location=1;
    diameter=RA*2;
else
    Tau=Tau2;
    compress=sigmacompress2;
    Bend=sigmabend2;
    location=2;
    diameter=RB*2;
end
%%