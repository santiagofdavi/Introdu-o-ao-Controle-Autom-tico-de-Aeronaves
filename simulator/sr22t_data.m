% Dados do Cirrus SR22T
% Fonte: http://www.airliners.net/info/stats.main?id=145

% Weights:
% Empty 837kg (1845lb), max takeoff 1406kg (3100lb).

% Performance:

% Max speed 346km/h (187kt), economical cruising speed 232km/h (125kt).
% Initial rate of climb 1040ft/min. Service ceiling 20,000ft. Range 1870km (1010nm).

% Powerplants:
% One 175kW (235hp) Lycoming O-540-L3C5D turbocharged flat six.


%% ---------------------------------------------------- %%

% Dados do aviao Cirrus SR22T
% Fonte: FlightGear versao 0.9.2

% Indicacao se o modelo ser usado para
% simulacao ou determinacao da cond. de equilibrio.
isTrimming = 0;

% Dados geometricos
% ft -> m
% Area da asa DONE
Sw = 144.92*0.09290304;
% Comprimento da asa DONE
Bw = 25.99*0.3048;
% Corda media da asa DONE
Cw = 5.58*0.3048;

% Momentos de inercia e produto de inercia DONE
% slug*ft^2 -> kg*m^2
Jxx = 897*1.3558179;
Jyy = 20699*1.3558179;
Jzz = 19876*1.3558179;
Jxz = 0;

% Massa da aeronave DONE
% lb (pounds) -> kg.
M = 2348*0.45359237;

% Posicao do c.g. nominal e atual, no referencial estrutural. DONE
% in (inches) -> m : (*25.4e-3)
Aero_RP = [-1.145  0.0 -0.53]*[-1 0 0;0 1 0;0 0 -1];
% Adicionado pra fazer o braço de alavanca da diferença entre AeroRP 
% e CG
Rcg = [-1.25 0.00 -0.54]*[-1 0 0;0 1 0;0 0 -1];
RaeroRP_CG = Aero_RP - Rcg;
% RaeroRP_CG = RaeroRP_CG*[-1 0 0;0 1 0;0 0 -1];
% Aero_RP = Rcg;

% Posicao do motor DONE
% in (inches) -> m : (*25.4e-3)
%%% Correcao para a posicao do propulsor, ao inves 
%%% da posicao do motor. Na JSBSim faz-se diferenciacao
%%% em relacao a isto. Para nos importa onde estah 
%%% aplicado o vetor forca propulsiva.
%%% Linha [206], arquivo "SR22T-jsb.xml". 
Rengine = [-3.6 0.0 -0.09045]*[-1 0 0;0 1 0;0 0 -1];
% JÁ VEIO MULTIPLICADO POR ESSA MATRIZ
Rengine_CG = Rengine - Rcg;
% Rengine_CG = Rengine_CG*[-1 0 0;0 1 0;0 0 -1];

% Estimativa de tracao maxima = Peso (g = 10m/s^2)
Tmax = M*10;  % DONE

% Limites dos comandos da aeronave: DONE (menos o último)
%%% Aqui o mais seguro eh defletir as superficies no simulador
%%% e observar os valores minimos e maximos das propriedades
%%% usadas nos calculos aerodinamicos.
aileron_limits = [-0.35 0.35];
rudder_limits = [-0.35 0.35];
elevator_limits = [-0.35 0.35];
thrust_limits = [0 1];  % TODO

x0 = zeros(12,1);
x0(3) = 3810;     % H (m)
x0(4) = 87.83; % U (m/s)
x0(6) = -0.95316; % W (m/s)
xo(8) = -4.5017e-27;
x0(11) = -0.010851; % theta (rad)

u0 = [0, -0.013822, 0, 0.11837].';

% Dados aerodinamicos

% ----------------- LIFT -----------------------%

% Mudanca em CL devido a proximidade do solo. TODO
% Variavel de entrada: aero/h_b-mac-ft (altura em rela�o ao solo da asa na posicao
% da MAC dividida pelo comprimento da asa - wingspan)
% Obs.: Fator multiplicativo
% CL_ground_effect = ...
% 	     [0.0   1.203;
%              0.1   1.127;
%              0.15  1.090;
%              0.2   1.073;
%              0.3   1.046;
%              0.4   1.055;
%              0.5   1.019;
%              0.6   1.013;
%              0.7   1.008;
%              0.8   1.006;
%              0.9   1.003;
%              1.0   1.002;
%              1.1   1.0];

% CL quando alpha = 0. DONE
CL_zero = 0.300;

% CL devido a alpha. DONE
% Entrada: alpha (rad). 
CL_alpha = ...
        [-0.20 -0.750
        0.00  0.300
        0.23  1.200
        0.60  0.710];

% CL devido a deflexao do Flap
% Entrada: comando de flap (adimensional).
% Originalmente, dezenas de graus de deflexao do flap.
% COMENTADO PORQUE O FLAP NAO MUDA
% CL_flap = ...
%         [0   0
%          1  0.20
%          2  0.30
%          3  0.35];

% CL devido a derivada de alpha. DONE
% TODO: perguntar para o Leo se tem que multiplicar por cw/(2*Vt) e alpha_dot
% Obs.: valor constante multiplicado por cw/(2*Vt) e por alpha_dot (rad/s).
% CL_alpha_dot = 0.01666;

% CL devido a derivada de theta = q.
% Entrada: pitch rate q (rad/s).
% Obs.: valor constante multiplicado por cw/(2*Vt)
CL_q = 3.9 * 0;  % TODO

% CL devido a defexao do profundor. DONE
% Obs.: Coef. multiplicativo para deflexao do prof. (rad).
CL_elev = 0.15;

% ----------------- DRAG -----------------------%

% CD quando alpha = 0.
CD_zero = 0.028;

CD_ind = 0.007;

% CD devido a alpha. 
% Entrada: alpha (rad).
CD_alpha = ...
	[-1.57    1.500
		-0.36    0.036
		0.00    0.028
		0.36    0.036
		1.57    1.500];

% CD devido a beta. DONE 
%% (ANTES ERA ESCALAR, VIROU TABELA)
% Obs.: Coef. multiplicativo para beta (rad).
CD_beta =  ...
	 [-1.57    1.230
         -0.26    0.050
         0.00    0.000
         0.26    0.050
         1.57    1.230];

CD_elev = 0.01;

CD_mach = [0, 0;
           0.7, 0;
           1.1, 0.023;
           1.8, 0.015];

% CD devido a posicao do Flap.
% Entradas: alpha (rad) e comando de flap (0, 1, 2 ou 3).
% Obs.: entrada 1 -> coluna 1 (2:end,1)
%       entrada 2 -> linha 1 (1,2:end)
% CD_flap = ...
%          [  0           0               1          2           3
%          -0.087266    0.000000    0.002967    0.008441    0.015301
%          -0.069813    0.000000    0.006098    0.013138    0.020781
%          -0.052360    0.000000    0.009230    0.017836    0.026261
%          -0.034907    0.000000    0.012361    0.022533    0.031741
%          -0.017453    0.000000    0.015493    0.027230    0.037221
%           0.000000    0.000000    0.018624    0.031927    0.042702
%           0.017453    0.000000    0.021812    0.036710    0.048281
%           0.034907    0.000000    0.025001    0.041492    0.053860
%           0.052360    0.000000    0.028189    0.046274    0.059439
%           0.069813    0.000000    0.031377    0.051056    0.065019
%           0.087266    0.000000    0.034565    0.055838    0.070598
%           0.104720    0.000000    0.037753    0.060621    0.076177
%           0.122173    0.000000    0.040942    0.065403    0.081757
%           0.139626    0.000000    0.044129    0.070185    0.087336
%           0.157080    0.000000    0.046078    0.073107    0.090745
%           0.174533    0.000000    0.047998    0.075989    0.094107
%           0.191986    0.000000    0.049920    0.078871    0.097469
%           0.209439    0.000000    0.051841    0.081752    0.100831
%           0.226893    0.000000    0.053810    0.084706    0.104277
%           0.244346    0.000000    0.055911    0.087858    0.107954
%           0.261799    0.000000    0.058224    0.091327    0.112001
%           0.279253    0.000000    0.058978    0.092458    0.113320
%           0.296706    0.000000    0.058067    0.091092    0.111727
%           0.314159    0.000000    0.056682    0.089014    0.109303
%           0.331613    0.000000    0.054587    0.085871    0.105636
%           0.349066    0.000000    0.048493    0.076730    0.094971];


% ----------------- SIDE -----------------------%

% CY devido a beta. DONE 
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por beta.
CY_beta = -1;

% CY devido a roll rate - p.
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por p (rad/s) e por bw/(2*VT).
CY_p = ...
	[0.0000  -0.075
         0.0943  -0.145];

% CY devido a yaw rate - r.
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por r (rad/s) e por bw/(2*VT).
CY_r = ...
	[0.0000   0.214
         0.0943   0.267];

% CY devido a deflexao do leme.
% Obs.: coeficiente multiplicativo para delta_rudder (rad).
CY_rudder = 0.187;

% ----------------- Roll -----------------------%

% Cl devido a beta.
%% (ERA TABELA, VIROU ESCALAR)
% Entradas: beta (rad) e alpha (rad).
% Obs.: entrada 1 -> coluna 1 (2:end,1)
%       entrada 2 -> linha 1 (1,2:end)
Cl_beta = -0.1;

% Cl devido a roll rate - p.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por p (rad/s) e por bw/(2*VT).
Cl_p = -0.4;

% Cl devido a yaw rate - r.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por p (rad/s) e por bw/(2*VT).
Cl_r = 0.15;

% CY devido a deflexao do aileron. DONE
% Obs.: coeficiente multiplicativo para aileron (rad).
Cl_ail = 0.1;

% CY devido a deflexao do leme.
% Obs.: coeficiente multiplicativo para leme (rad).
Cl_rudder = 0.01;


% ----------------- Pitch -----------------------%

% Cm para alpha = 0.
Cm_zero = 0.0; % o correto é 0.00

% Cm devido a alpha.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
Cm_alpha = -0.8;

% Cm devido a alpha rate.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por alpha_dot (rad/s) e por cw/(2*VT).
Cm_alpha_dot = -7;

% Cm devido a pitch rate - q.
% Obs.: coeficiente multiplicativo para q (rad/s) e (cw/(2*VT)).
Cm_q = -15; % o correto é -15

% Cm devido a deflexao do flap.
% Entrada: comando do flap (0, 1, 2 ou 3).
% Obs.: Coeficiente adicionado ao Cm final.
% Cm_flap = ...
% 	  [0    0
%           1  -0.0654
%           2  -0.0981
%           3  -0.1140];

% Cm devido a deflexao do profundor. DONE
% Entrada: alpha (rad). (na verdade é número de mach)
% Obs.: Coeficiente multiplicado pela deflexao de profundor.
Cm_elev = [0.0, -1.100;
           2.0, -0.275]; 

% ----------------- YAW ----------------------%

% Cn devido a beta.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por beta.
Cn_beta = 0.12;

% Cn devido a roll rate - p.
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por p e por (bw/(2*VT)).
% Cn_p = ...
% 	[0.0000  -0.0278
%           0.0943  -0.0649];

% Cn devido a yaw rate - r.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por r e por (bw/(2*VT)).
Cn_r = -0.15;

% Cn devido a deflexao de aileron.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por delta_ail (rad).
Cn_ail = -0.01;

% Cn devido a deflexao de leme.
%% (ERA TABELA, VIROU ESCALAR)
% Entrada: alpha (rad).
% Obs.: Coeficiente multiplicado por delta_rudder (rad).
Cn_rudder = -0.15;









