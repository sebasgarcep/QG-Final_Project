clc;
clear all;
close all;

manager = QGManager();

% Actual initial solution of the system
QG0 = manager.read('QG0.nc');

% Creating an initial background state dynamically consistent with the
% dynamics of the model QG
QGb = QG0 + 0.05 * randn(129,129) .* QG0;
manager.propagate(QGb, 100, 'QGb.nc');
filename = 'QGtemp';

% Variables
N = 1000;
t = 12;
n = 127;
gridsize = n ^ 2;

% Create data stores
ens = zeros(t * gridsize, N);
y = zeros(t * gridsize, 1);
real = zeros(t * gridsize, 1);

% Generating the initial ensemble
for e = 1:N
    disp(['* Generating ensemble # ', num2str(e)]);
    QGe_prev = manager.read('QGb.nc');
    for k = 1:t
        disp(['* Generating time ', num2str(k)]);
        QGe = QGe_prev + 0.05 * randn(129,129) .* QGe_prev;
        manager.propagate(QGe, 100, filename);
        QGe_prev = manager.read(filename);
        
        mat = QGe_prev(2:(n + 1), 2:(n + 1))';
        vec = mat(:);
        ens((1 + (k - 1) * gridsize):(k * gridsize), e) = vec;
    end
end

% Shift the actual state to current time
manager.propagate(QG0, 100, 'QGbase.nc');

% Obtain snapshots of reality and observations at all pertinent times
QGbase = manager.read('QGbase.nc');

QGa_prev = QGbase;
QGy_prev = QGbase;
for k = 1:t
    idx = (1 + (k - 1) * gridsize):(k * gridsize);
    
    disp(['* Generating reality ', num2str(k)]);
    
    QGy_prev = QGa_prev;
    
    manager.propagate(QGa_prev, 100, filename);
    QGa_prev = manager.read(filename);
    
    mat = QGa_prev(2:(n + 1), 2:(n + 1))';
    vec = mat(:);
    real(idx, 1) = vec;

    disp(['* Generating observation ', num2str(k)]);
    
    QGy = QGy_prev + 0.01 * randn(129,129) .* QGy_prev;
    manager.propagate(QGy, 100, filename);
    QGy_prev = manager.read(filename);
    
    mat = QGy_prev(2:(n + 1), 2:(n + 1))';
    vec = mat(:);
    y(idx, 1) = vec;
end

save experiment ens y real;
