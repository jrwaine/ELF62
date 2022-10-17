s = tf("s");

g = (s+7) / (s*(s + 5)*(s + 15)*(s + 20));
k = 1;

h = feedback(k*g, 1);

% display(h);
% h =
%  
%                  s + 7
%   -----------------------------------
%   s^4 + 40 s^3 + 475 s^2 + 1501 s + 7

% 2. a) Compare o seu esboço do lugar das raízes com o lugar das raízes 
% obtido no Matlab

% rlocus(g);

% b) Usando a ferramenta SISOTOOL, apresente um ganho que garanta que o 
% sistema tenha um tempo de acomodação menor que 2s, um sobre sinal máximo 
% de 10% e uma margem de ganho mínima de 20 dB.

sisotool(g);

% Design Data
% Name: Design1
% Sample Time: 0
% Value:
% 
% C =
%  
%   676.62
%  
% F =
%  
%   1

% A partir da imagem é possível perceber que o sistema obedece as
% restrições requisitadas com o valor de ganho de 676.62

% c) Comprove que a resposta do sistema em malha fechada para entrada degrau está
% atende os objetivos de projeto

k = 676.62;
hh = feedback(k*g, 1);

% display(hh);
% hh =
%  
%               676.6 s + 4736
%   --------------------------------------
%   s^4 + 40 s^3 + 475 s^2 + 2177 s + 4736
S = stepinfo(hh);

% margin(k*g);
% display(S);
% S = 
% 
%   struct with fields:
% 
%          RiseTime: 0.4500
%     TransientTime: 1.3622
%      SettlingTime: 1.3622
%       SettlingMin: 0.9069
%       SettlingMax: 1.0522
%         Overshoot: 5.2222
%        Undershoot: 0
%              Peak: 1.0522
%          PeakTime: 0.9710

% É possível perceber que o overshoot é de 10%, o tempo de acomodação é de
% 1.36s e a margem de ganho é de 21.5dB

% 2. d) Na tela SISOTOOL, acrescente o comportamento de erro do sistema 
% com o ganho projetado.

% Na imagem 2d

% 2. e) Comprove o erro em regime observado com o erro calculado através 
% do teorema do valor final.

% Na imagem