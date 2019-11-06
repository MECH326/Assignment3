function [ MaxStress ] = Stresses( A,B,F1,F2,R1,R2,R3,p,T,M1,M2 )
%Taking forces on A, A and forces on B, the gear forces F1 and F2
%   Detailed explanation goes here

%% Finding moment at the shoulders
M1Z=-A(2)*(.175)+p*PI()*R1^2*(.175)^2;
M1Y=A(3)*(.175)+F1(1)*.1;

M1=sqrt(M1Z^2+M1Y^2);
sigmabend1=

M2Z=-A(2)*(.675)+F1(2)*.4+M1*.4+p*PI()*R1^2*(.675)^2+p*PI()*R2^2*(.4)^2;
M2Y=A(3)*(.175)+F1(1)*.1-F1(2)*.4;

M2=sqrt(M2Y^2+M2Z^2)


%% check which is critical moment

