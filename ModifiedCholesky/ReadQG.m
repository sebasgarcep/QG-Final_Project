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
m = 127;
dev = 0.01;

% Create data stores
Xens = zeros(N, t, n, m);
Xr = zeros(t, n, m);
Xy = zeros(t, n, m);

% Generating the initial ensemble
for e = 1:N
    disp(['* Generating ensemble # ', num2str(e)]);
    QGe = manager.read('QGb.nc');
    QGe = QGe + 0.05 * randn(129,129) .* QGe;
    for k = 1:t
        disp(['* Generating time ', num2str(k)]);
        manager.propagate(QGe, 100, filename);
        QGe = manager.read(filename);
        mat = QGe(2:(n + 1), 2:(n + 1));
        Xens(e, k, :, :) = mat;
    end
end

% Shift the actual state to current time
manager.propagate(QG0, 100, 'QGbase.nc');

% Obtain snapshots of reality and observations at all pertinent times
QGa = manager.read('QGbase.nc');
for k = 1:t
    QGy = QGa;
    
    disp(['* Generating reality ', num2str(k)]);
    manager.propagate(QGa, 100, filename);
    QGa = manager.read(filename);
    mat = QGa(2:(n + 1), 2:(n + 1));
    Xr(k, :, :) = mat;
    
    disp(['* Generating observation ', num2str(k)]);
    QGe = QGe + dev * randn(129,129);
    manager.propagate(QGy, 100, filename);
    QGy = manager.read(filename);
    mat = QGy(2:(n + 1), 2:(n + 1));
    Xy(k, :, :) = mat;
end

save SampleQG Xens Xr Xy;
