%% Assume diameters
% Chosen smallest possible diameters (Table 11-2) as initial iteration
d1 = 0.0175;  % gear shoulder (must be 5-15 mm greater than gear bore)
d2 = 0.0125;  % gear bore
d3 = 0.010;    % bearing bore

w_H = 6.3*9.81;  % weight of helical gear
w_S = 12.6*9.81; % weight of spur gear

r_H = 660/6600; % radius of helical gear
r_S = 660/3300; % radius of spur gear

F_H = [900 -6600 -2400];    % forces on helical gear
F_S = [0 -1200 -3300];      % forces on spur gear

[A, B] = calc_reaction_forces(d1, d2, F_H, F_S);

%% Determine moments/stresses @ helical gear shoulder
Mz = Ay*0.225-(Ay-6600-w_H)*0.050;

My = Az*0.225-(Az-2400)*0.050 + (900*r_H);

% Stress conc. factors
Kt = 1.8;   % r/d = 0.08, D/d = 1.4 read graph A-15-9
Kts = 1.45; % same ratios read graph A-15-8;

% Von Mises alternating
% Fully reversed x and y stresses, zero midrange
% Zero alternating torque

M_a = sqrt(Mz^2 + My^2);

sigma_a = 32*Kt*M_a/(pi*d2^3);
tau_a = 0;

sigma_a_prime = sqrt(sigma_a^2 + 3*tau_a^2);

% Von Mises midrange
% Zero midrange nominal stress

T_m = 660;

sigma_m = 0;
tau_m = 16*Kts*T_m/(pi*d2^3);

sigma_m_prime = sqrt(sigma_m^2 + 3*tau_m^2);

%% Check for yield
sigma_max = sqrt((sigma_a + sigma_m)^2 + 3*(tau_a + tau_m)^2);

Sy = 294.74e6;

n = Sy/sigma_max;

%% Check for fatigue
Sut = 394.72e6;
Se = 0.5*Sut;



% Find q and q_s, Kf and Kfs

% Use Soderberg criteria (most conservative)