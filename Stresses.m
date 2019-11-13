function [ Bend,compress,Tau,location,diameter] = Stresses( A,B,F1,F2,RA,Rmid,RB,p,T,M1,M2 )
%Taking forces on A, A and forces on B, the gear forces F1 and F2
%   Detailed explanation goes here

%% getting moments of inertia
[I,J]=compute_moments(2*RA,2*Rmid,2*RB);
%% Finding moment at the shoulders
M1Z=-A(2)*(.175)+9.81*p*pi()*RA^2*(.175)^2/2;
M1Y=A(3)*(.175)+F1(1)*.1;

M1=sqrt(M1Z^2+M1Y^2);
sigmabend1=M1/I(1);

M2Z=-A(2)*(.675)+F1(2)*.4+M1*.4+9.81*p*pi()*RA^2/2*(.675)^2+9.81*p*pi()*Rmid^2*(.4)^2/2;
M2Y=A(3)*(.175)+F1(1)*.1-F1(2)*.4;

M2=sqrt(M2Y^2+M2Z^2);
sigmabend2=M2/I(3);


%% stress due to compression

sigmacompress1=0;
sigmacompress2=F1(1)/(pi*RB^2);


%% shear stress due to torsion
Tau1=T/J(1);
Tau2=T/J(3);

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