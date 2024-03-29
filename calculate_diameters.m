%% Assume diameters
% Chosen smallest possible diameters (Table 11-2) as initial iteration
d1 = 0.095;  % gear shoulder (must be 5-15 mm greater than gear bore)
d2 = 0.090;  % gear bore
d3 = 0.080;    % bearing bore

[A, B] = calc_reaction_forces(d2, d1, d2);

F_H = [900 -6600 -2400];    % N
F_S = [0 -1200 -3300];      % N
M_H = 6.3;  % kg
M_S = 12.6; % kg
p = 7870;   % kg/m^3
T = 660;
R_H = abs(T/F_H(2));
R_S = abs(T/F_S(3));

[sigma_bend, sigma_axial, tau, location, d] = Stresses(A,B,F_H,F_S,d2/2,d1/2,d2/2,p,T,M_H, M_S, R_H, R_S);

Kt_bend = 2.2;
Kt_axial = 2.2;
Kts = 1.5;
q_bend = 0.65;
q_axial = 0.65;
qs = 0.7;

[n_yield, n_fatigue] = yield_fatigue_analysis(sigma_bend, ...
    sigma_axial, tau, Kt_bend, Kt_axial, Kts, q_bend, q_axial, qs, d);

n_desired = 3.0;

pass_critical_speed = CorrectCriticalSpeed(d2, d1, d2, n_desired);

pass_deflection = deflection(d2, d1, d2);