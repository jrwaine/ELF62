%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercício b)

% Considerando a equação 10u(t) = dy^2/dt^2 + 5dy/dt + 10y(t)
% Temos que u(t) = 0.1*dy^2/dt^2 + 0.5*dy/dt + y(t)
% Portanto U(s) = 0.1*s^2*Y(s) + 0.5*s*Y(s) + 1*Y(s)
% Y(s) = U(s) * 1 / (0.1*s^2 + 0.5*s + 1)
% Y(s)/U(s) = H(s) = 1 / (0.1*s^2 + 0.5*s + 1)

s = tf("s");
func = 1 / (0.1*s^2+0.5*s+1);
step(func);
hold

% Os resultados obtidos com relação ao simulink são os mesmos
% (ou muito semelhante ao menos)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercício c)

func_fb = feedback(func, 1);
step(func_fb);
disp(func_fb);
% den = 0.1*s^2+0.5^2+2
% Equação característica: s^2+5s^2+20=0

% Raízes da equação características: (-5 +- sqrt(-55))/2 
% Sistema com duas raízes imaginárias conjugadas no semiplano negativo

% O tempo de acomodação diminui 
% O sobressinal aumenta
% O sinal de erro aumenta, deixa de ser zero, com a função estabilizando em
% 0.5 ao invés de 1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exercício d)

func_fb_10 = feedback(func*10, 1);
func_fb_2 = feedback(func*2, 1);

step(func_fb_10);
hold;
step(func_fb_2);
step(func_fb);

% O tempo de acomodação dos é constante com relação ao caso de feedback
% O sobressinal do caso com 10 é muito maior que o com 2 de ganho

[num_f10, den_f10] = tfdata(func_fb_10);
[num_f2, den_f2] = tfdata(func_fb_2);

root_f10 = roots(den_f10{1});
root_f2 = roots(den_f2{1});

disp(root_f10);
disp(root_f2);

% As raízes são
% Para ganho 10: -2.5000 +- 10.1858i
% Para ganho 2: -2.5000 +- 4.8734i
% É possível perceber que a parte real continua constante, enquanto a parte
% imaginária da raíz aumenta de um caso para o outro.
% Esse aumento afeta o sobressinal (não lembro o pq disso de ASLIN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Exercício 2
