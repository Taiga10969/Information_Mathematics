% ニュートンの運動法則を用いた2Dシミュレーション (バウンドあり)

% 初期条件と定数
mass = 1.0;             % 質量 (kg)
position = [0, 0];      % 初期位置 [x, y] (m)
velocity = [5, 15];     % 初速度 [vx, vy] (m/s)
g = 9.81;               % 重力加速度 (m/s^2)
air_resistance = 0.1;   % 空気抵抗係数 (N/(m/s))
restitution = 0.8;      % バウンド時の速度減衰率 (1: 完全弾性衝突, <1: 非弾性衝突)

% シミュレーションパラメータ
dt = 0.01;              % 時間刻み (s)
T = 10;                 % シミュレーション時間 (s)
time_steps = T / dt;    % 時間ステップ数

% アニメーションの設定
figure;
hold on;
grid on;
axis([0 35 0 15]); % 描画領域 [xmin xmax ymin ymax]
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Projectile Motion with Bouncing and Air Resistance');
plot_handle = plot(0, 0, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b'); % 動く物体
trajectory_handle = plot(0, 0, 'r-', 'LineWidth', 1.5); % 軌跡

% シミュレーションループ
positions = zeros(time_steps, 2); % 位置の記録用
for t = 1:time_steps
    % 力の計算
    gravity = [0, -mass * g];                          % 重力
    air_drag = -air_resistance * velocity;             % 空気抵抗
    net_force = gravity + air_drag;                    % 合力
    
    % ニュートンの運動法則
    acceleration = net_force / mass;                   % 加速度
    
    % 速度と位置の更新
    velocity = velocity + acceleration * dt;           % 速度更新
    position = position + velocity * dt;               % 位置更新
    
    % 地面に衝突した場合の処理 (バウンド)
    if position(2) < 0
        position(2) = 0;                               % 地面より下に行かない
        velocity(2) = -velocity(2) * restitution;      % y速度を反転して減衰
        if abs(velocity(2)) < 0.1                     % 速度が非常に小さい場合停止
            break;
        end
    end
    
    % 記録
    positions(t, :) = position;
    
    % アニメーションの更新
    set(plot_handle, 'XData', position(1), 'YData', position(2)); % 物体の位置
    set(trajectory_handle, 'XData', positions(1:t, 1), 'YData', positions(1:t, 2)); % 軌跡
    
    pause(0.01); % アニメーション速度
end

% 最終フレームを保持
disp('Simulation Complete');
