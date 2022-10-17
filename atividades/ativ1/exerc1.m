s = tf("s");

g = 5000 / (s^3+501*s^2+500*s);
k = 1;

h = feedback(k*g, 1);
display(h);

% h =
%               5000
%   ----------------------------
%   s^3 + 501 s^2 + 500 s + 5000

% bodeplot(h);


% 1. b) Verifique qual o ponto de cruzamento de ganho, o ponto de cruzamento 
% de fase, a margem de ganho e a margem de fase. O sistema é estável?

% margin(h)
% Gm = 33.8 dB (48.98 em ganho) (em 22.4 rad/s) 
% Pm = 24.8 graus (em 4.36 rad/s)

% margin(g)
% Gm = 34.0 dB (~50.12 em ganho) (em 22.4 rad/s) 
% Pm = 17.6 graus (em 3.08 rad/s)

% O sistema para tal configuração de ganho e feedback é estável

% 1. c) Confirme a margem de ganho e a estabilidade usando o lugar das 
% raízes do sistema.

sisotool(g);

% Design Data
% Name: Design1
% Sample Time: 0
% Value:
% 
% C =
%  
%   49.628
%  
% F =
%  
%   1

% A partir da imagem é possível ver que o ganho para um sistema 
% estável é de aproximadamente 49.63, que é a margem de ganho.
% A perda de precisão se dá pela conversão de unidades

% 1. d)

% Feito no 1.b) já

% 1. e)
% Design Data
% Name: Design2
% Sample Time: 0
% Value:
% 
% C =
%  
%   1.3195
%  
% F =
%  
%   1

% O ganho é de 0.77874 para uma marge de fase de 20 graus.

% 1. f)

% Imagem 1f
