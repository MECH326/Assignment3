function [n_yield, n_fatigue] = yield_fatigue_analysis(sigma_bend, sigma_axial, tau, Kt_bend, Kt_axial, Kts, q_bend, q_axial, qs, d)
    %% Calculate Kf, Kfs
    Kf_bend  = q_bend*(Kt_bend - 1) + 1;
    Kf_axial = q_axial*(Kt_axial -1) + 1;
    Kfs = qs*(Kts - 1) + 1;

    % Von Mises alternating
    % Fully reversed x and y stresses, zero midrange
    % Zero alternating torque
    
    sigma_a_bend = sigma_bend;
    sigma_a_axial = 0;
    tau_a = 0;

    sigma_a_prime = sqrt((Kf_bend*sigma_a_bend + Kf_axial*sigma_a_axial/0.85)^2 + 3*Kfs*tau_a^2);   % Shigleys Eq. 6-55

    % Von Mises midrange
    % Zero midrange nominal stress
    % Can ignore midrange Kf, Kfs since shaft is ductile

    sigma_m_bend = 0;
    sigma_m_axial = sigma_axial;
    tau_m = tau;

    sigma_m_prime = sqrt((Kf_bend*sigma_m_bend + Kf_axial*sigma_m_axial)^2 + 3*Kfs*tau_m^2);    % Shigleys Eq 6-56

    %% Check for yield
    sigma_max_prime = sigma_a_prime + sigma_m_prime;    % Conservative simplification

    Sy = 350e6;

    n_yield = Sy/sigma_max_prime;

    %% Check for fatigue
    Sut = 420e6;
    Se_prime = 0.5*Sut;
    % Determine Marin factors
    ka = (4.51)*Sut^(-0.265); % hot-rolled surface finish
    if d < 0.051
        kb = 1.24*d^(-0.107);
    else
        kb = 1.51*d^(-0.157);
    end
    % Shigleys: When torsion is combined with other stresses, such as
    % bending, kc = 1 and the combined loading is managed by using the effective von Mises stress as in Sec. 5–5.
    % Note: For pure torsion, the distortion energy predicts that (kc)torsion = 0.577.
    kc = 1; 
    kd = 1;
    ke = 1;
    kf = 1;
    
    Se = ka*kb*kc*kd*ke*kf*Se_prime;
    
    % Use Soderberg criteria (most conservative)
    n_fatigue = 1/(sigma_a_prime/Se + sigma_m_prime/Sy);
end

