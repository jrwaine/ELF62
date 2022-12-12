norm = 15.2;
num = [0.02505] / norm;
% Poles: -0.2671, -0.006126
% Dominant pole, clearly
den = [1, 0.2732, 0.001636];

s = tf("s");
sys = tf(num, den);

% controlSystemDesigner(sys);

C = 0.041957 * (1 + 1.3e+02*s) / s;
Kp = 0.041957 * 1.3e+02;
Ki = 0.041957;

% Real zero: -0.00792
% Integrator: 0

tf_feedback = feedback(C * sys, 1);

% tf_feedback =
% 
%             0.00123 s + 1.025e-05
%   -----------------------------------------
%   s^3 + 0.2732 s^2 + 0.002866 s + 1.025e-05
% 
% Continuous-time zero/pole/gain model.
%
%           0.0012295 (s+0.008333)
%  ---------------------------------------
%  (s+0.2624) (s^2 + 0.01077s + 3.904e-05)
%
% Continuous-time zero/pole/gain model.

%step(sys);
hold
S = stepinfo(tf_feedback);
% step(tf_feedback);
% legend("plant", "feedback");

hold off;

t = 1:600;
u = 1:600;
u(1:600) = 2 / norm;
u(100:200) = 4 / norm;
u(200:400) = 10 / norm;
u(400:600) = 6 / norm;

% lsim(tf_feedback, u, t);
% ylim([0, 1]);

hold on;

% matrix_resp = readmatrix("control_signal_response.csv");
matrix_resp = readmatrix("control_signal_response.csv");
temp = matrix_resp(:, 2);
temp_goal = matrix_resp(:, 3);
temp_initial = matrix_resp(:, 4);
temp_norm = (temp - temp_initial) / norm;
time_sec = matrix_resp(:, 1);
% plot(time_sec, temp_norm, "-r");

hold off;

plot(time_sec, temp, "-b");
hold on;
plot(time_sec, temp_goal, "-g");
