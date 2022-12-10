matrix = readmatrix("step_response_temp.csv");

temp = matrix(:, 2);
temp_norm = temp - temp(1);
secs = matrix(:, 1);

% Number of poles
np = 2;

y = temp;
u = zeros(size(secs));
u(2:length(u)) = 1;

num = [0.02505];
% Poles: -0.2671, -0.006126
% Dominant pole, clearly
den = [1, 0.2732, 0.001636];

s = tf("s");
sys = tf(num, den);

step(sys);
hold
plot(temp_norm);

