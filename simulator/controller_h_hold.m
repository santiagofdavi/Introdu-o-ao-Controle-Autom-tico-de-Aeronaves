clear all;
clc;

sr22t_data;

load('linsys1.mat');
load('op_trim1.mat');

tf_linsys1 = tf(linsys1);

%% Denominator of all TFs

Den = tf_linsys1(3,2).Denominator{1,1};

%% Numerator of each TF with respect to the Elevator

He = tf_linsys1(3,2).Numerator{1,1};

Ue = tf_linsys1(4,2).Numerator{1,1};

We = tf_linsys1(6,2).Numerator{1,1};

Qe = tf_linsys1(8,2).Numerator{1,1};

Thetae = tf_linsys1(11,2).Numerator{1,1};

%% Numerator of each TF with respect to the Thrust

Ht = tf_linsys1(3,4).Numerator{1,1};

Ut = tf_linsys1(4,4).Numerator{1,1};

Wt = tf_linsys1(6,4).Numerator{1,1};

Qt = tf_linsys1(8,4).Numerator{1,1};

Thetat = tf_linsys1(11,4).Numerator{1,1};

%% Trimming States and Inputs Values

x0 = zeros(12,1);
x0(3) = op_trim1.States(1,1).x;     % H (m)
x0(4) = op_trim1.States(4,1).x;     % U (m/s)
x0(6) = op_trim1.States(5,1).x;     % W (m/s)
x0(8) = op_trim1.States(2,1).x;     % Q (rad/s)
x0(11) = op_trim1.States(3,1).x;    % theta (rad)

u0 = [op_trim1.Inputs(1,1).u, op_trim1.Inputs(2,1).u, op_trim1.Inputs(3,1).u, op_trim1.Inputs(4,1).u].';

%% Gain values

% PI Controller
kp = 0.005; 
Ti = 17.5; 
tau = 30;
% Sintonia mostrada pro Leo
% kp = 0.009; 
% Ti = 6000; 
% tau = 20;
% Com overshoot grande, erro nulo ss
% kp = 0.0034;
% Ti = 2000;

% P Controller
Kp = 6; % [0.5, 3] 

% Loop interno SAS
Kq = 3; % [3, 10]

% Referência
Href = 0;
Href = 0.05 * x0(3);
% Href = -0.2 * x0(3);