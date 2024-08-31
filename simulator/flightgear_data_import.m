clear all;
clc;

sr22t_data;
%% Dados do primeiro voo (t_max = 413.2917) -> VÔO BOM
% T1 = readmatrix('data_matlab.csv');
% T = T1(16:end, :);
%% Dados do segundo voo (t_max = 260.6500)
% T1 = readmatrix('data - copia.csv');
% T = T1(16:end, :);
%% Dados do terceiro voo (t_max = 247.3167)
% T1 = readmatrix('data - matlab.csv');
% T = T1(14:end, :);
%% Dados do quarto voo (t_max = 274.1167)
% T1 = readmatrix('data.csv');
% T = T1(13:end, :);
%% Dados do quinto voo (t_max = 227.8750) 
% T1 = readmatrix('data3.csv');
% T = T1(13:end, :);
%% Dados do quarto voo (t_max = 269.5917) -> CG variante no tempo
% T1 = readmatrix('data_31072024.csv');
T1 = readmatrix('dados_31072024b.csv');
data = T1(15:end, :);

k = 1;
t = data(:, k);
    t = t - ones(length(t), 1);

tstart = t(1);
tstop = t(end);

k = k+1;
Vt = [t, data(:, k) * 0.3048]; % ft pra m
    Vt(1,2) = 0.1; % eps(0);

k = k+1; alpha = [t, data(:, k)];
k = k+1; beta = [t, data(:, k)];

k = k+1; roll = [t, data(:, k)];
k = k+1; pitch = [t, data(:, k)];
k = k+1; yaw = [t, data(:, k)];

k = k+1; P = [t, data(:, k)];
k = k+1; Q = [t, data(:, k)];
k = k+1; R = [t, data(:, k)];  

k = k+1; h = [t, data(:, k)];

k = k+1; aileron = [t, data(:, k)];
k = k+1; profundor = [t, data(:, k)];
k = k+1; leme = [t, data(:, k)];

flap = 0;

k = k+1; alpha_dot = [t, data(:, k)];

k = k+1; f_arrasto = [t, data(:, k) * 4.44822162]; % lbf pra N
k = k+1; f_sustentacao = [t, data(:, k) * 4.44822162];
k = k+1; f_lateral = [t, data(:, k) * 4.44822162];
% Criando vetor força de tração com componente apenas em x
k = k+1; f_tracao = [t, data(:, k) * 4.44822162, data(:, k) * 0, data(:, k) * 0];

    Faero_flightgear = [t, f_arrasto(:,2), f_lateral(:,2), f_sustentacao(:,2)];

k = k+1; m_roll = [t, data(:, k) * 1.3558179488411];
k = k+1; m_pitch = [t, data(:, k) * 1.3558179488411];
k = k+1; m_yaw = [t, data(:, k) * 1.3558179488411];

    Maero_flightgear = [m_roll, m_pitch(:,2), m_yaw(:,2)];

k = k+1; pressao_dinamica = [t, data(:, k) * 47.880268685];
k = k+1; pressao_dinamica_total = [t, data(:, k) * 47.880268685];

k = k+1; CGx = -data(:,k)/39.37;
k = k+1; CGy = data(:,k)/39.37;
k = k+1; CGz = -data(:,k)/39.37;
CG = [t, CGx,CGy,CGz];

%%% Nova variavel foi adicionada.
k = k+1; Mach = [t,data(:,k)];

% cl_beta_fg = [t, data(:, 24) * 1.3558179488411];
% cl_damp_fg = [t, data(:, 25) * 1.3558179488411];
% cl_yaw_fg = [t, data(:, 26) * 1.3558179488411];
% cl_ail_fg = [t, data(:, 27) * 1.3558179488411];
% cl_rudder_fg = [t, data(:, 28) * 1.3558179488411];
% 
k = k+1; cm_alpha_fg = [t, data(:, k) * 1.3558179488411/Cw/Sw];
k = k+1; cm_elev_fg = [t, data(:, k) * 1.3558179488411/Cw/Sw];
k = k+1; cm_damp_fg = [t, data(:, k) * 1.3558179488411/Cw/Sw];   
k = k+1; cm_alphadot_fg = [t, data(:, k) * 1.3558179488411/Cw/Sw];
% 
% cn_beta_fg = [t, data(:, 33) * 1.3558179488411];
% cn_damp_fg = [t, data(:, 34) * 1.3558179488411];
% cn_rudder_fg = [t, data(:, 35) * 1.3558179488411];
% cn_ail_fg = [t, data(:, 36) * 1.3558179488411];

% densidade = 1.225 * (25/15) ^ (-9.80665/(-6.5 * 287.04) - 1);
% densidade = 0.08;