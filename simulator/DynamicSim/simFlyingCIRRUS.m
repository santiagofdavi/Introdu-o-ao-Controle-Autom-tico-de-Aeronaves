close all;
clear all;

% Carregar imagens
[img, ~, alpha] = imread('CirrusSR22T.png');

% Carregar a imagem de fundo
background_img = imread('ceu.png');

% Definir a nova largura e altura da imagem
scale = 3;
new_width_pixels = 240; % Novo comprimento desejado em pixels (ajuste conforme necessário)
new_height_pixels = 20; % Nova altura desejada em pixels (ajuste conforme necessário)

% Obter dimensões da imagem original
[original_height, original_width] = size(img(:,:,1)); % Tamanho original em pixels

% Redimensionar a imagem para a nova largura e altura
img_resized = imresize(img, scale * [new_height_pixels, new_width_pixels]); % Ajustar largura e altura
alpha_resized = imresize(alpha, scale * [new_height_pixels, new_width_pixels]); % Ajustar largura e altura

% Atualizar dimensões da imagem redimensionada
[img_height_resized, img_width_resized] = size(img_resized(:,:,1));

data = load("states.mat");

u = data.data.u.Data;
w = data.data.w.Data;
altitude = data.data.h.Data;
theta = data.data.theta.Data;
q = data.data.q.Data;
posicao_x = data.data.P_N.Data;

time = data.data.h.Time;

figure;
title('Simulação do Piloto Automático Cirrus SR22T');
xlabel('Posição x [m]');
ylabel('Altitude [m]');
hold on;
% axis equal;

% Defina o intervalo fixo do eixo y (altitude)
y_fixed_min = 3500; % Limite inferior desejado
y_fixed_max = 4200; % Limite superior desejado

% Obtenha o tamanho do eixo
x_limits = [min(posicao_x)-100 max(posicao_x)+100];
y_limits = [y_fixed_min y_fixed_max];

% Redimensionar a imagem de fundo
background_img = flipud(imresize(background_img, [diff(y_limits), diff(x_limits)]));

% Exibir a imagem de fundo
h_bg = imagesc([min(posicao_x)-100 max(posicao_x)+100], ...
    [y_fixed_min y_fixed_max], background_img);
uistack(h_bg, 'bottom');  % Colocar a imagem de fundo no fundo

% Definir o tempo de atualização desejado em segundos
desired_interval = time(length(time)) / length(time); % Intervalo de tempo entre as iterações (ajuste conforme necessário)

% Obter o tempo de início
start_time = tic;

for i = 1:length(altitude)
    

    % Posição, rotação e dimensão da imagem
    x = posicao_x(i); % Posição no eixo x
    z = altitude(i); % Altitude atual
    theta_deg = rad2deg(theta(i)); % Ângulo de arfagem em graus

    % Rotacione a imagem do avião
    rotated_img = imrotate(img_resized, theta_deg, 'bilinear', 'crop');
    rotated_alpha = imrotate(alpha_resized, theta_deg, 'bilinear', 'crop');

    % Exiba a imagem no gráfico, ajustando a posição x e z
    img_width = size(rotated_img, 2);
    img_height = size(rotated_img, 1);

    rotated_img = flipud(rotated_img);
    rotated_alpha = flipud(rotated_alpha);

    h = image('XData', [x - img_width/2, x + img_width/2], ...
              'YData', [z - img_height/2, z + img_height/2], ...
              'CData', rotated_img);
    
    % Aplique a transparência usando o canal alfa
    set(h, 'AlphaData', rotated_alpha);

    % Inverter o eixo z
    set(gca, 'YDir', 'normal');
    axis([min(posicao_x)-100 max(posicao_x)+100 y_fixed_min y_fixed_max]);

    % Atualize o gráfico
    drawnow;

    % Pausa para manter o intervalo de tempo constante
    elapsed_time = toc(start_time); % Tempo decorrido desde o início
    pause_time = desired_interval - elapsed_time; % Tempo de pausa necessário
    
    if pause_time > 0
        pause(pause_time);
    end
    
    % Atualizar o tempo de início
    start_time = tic;

    % Limpar a imagem anterior
    delete(h);
end