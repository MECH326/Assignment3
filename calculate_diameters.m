%% Assume diameters
% Chosen smallest possible diameters (Table 11-2) as initial iteration
d1 = 0.0175;  % gear shoulder (must be 5-15 mm greater than gear bore)
d2 = 0.0125;  % gear bore
d3 = 0.010;    % bearing bore

w_H = 6.3*9.8;  % weight of helical gear
w_S = 12.6*9.8; % weight of spur gear

%% Determine COM of shaft
x = (0.1125*0.225*pi*(d2^2)/4 + 0.325*0.3875*pi*(d1^2)/4 + 0.15*0.625*pi*(d2^2)/4)/ ...
    (0.225*pi*(d2^2)/4 + 0.325*pi*(d1^2)/4 + 0.15*pi*(d2^2)/4);

%% Determine radii of gears
r_H = 660/6600

r_S = 660/3300

%% Determine reaction forces at A and B
Ax = 0; % A is not locating bearing

% Find Ay: Balance z-moments about B
Ay = ((1200+w_S)*0.150 + (6600+w_H)*0.625)/0.70;

% Find Az: Balance y-moments about B
Az = (3300*0.150 + 2400*0.625)/0.70;

A = [Ax Ay Az];

Bx = -900;  % B is locating bearing

% Find By: Balance z-moments about A
By = ((1200+w_S)*0.700 + (6600+w_H)*0.225)/0.70;

% Find Bz: Balance y-moments about A
Bz = (3300*0.700 + 2400*0.225)/0.70;

B = [Bx By Bz];

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



