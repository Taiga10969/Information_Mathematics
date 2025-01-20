function bouncing_simulation_with_ui()
    % ハイパーパラメータを変更可能なUI付き物体運動シミュレーション

    % 初期設定
    default_params = struct(...
        'mass', 1.0, ...
        'initial_x', 0, ...
        'initial_y', 0, ...
        'initial_vx', 5, ...
        'initial_vy', 15, ...
        'gravity', 9.81, ...
        'air_resistance', 0.1, ...
        'restitution', 0.8 ...
    );

    % UIの作成
    f = figure('Name', 'Simulation Parameters', 'NumberTitle', 'off', 'Position', [100, 100, 600, 400]);

    % パラメータ入力用のUIコントロール
    uicontrol(f, 'Style', 'text', 'Position', [20, 360, 150, 20], 'String', 'Mass (kg)');
    mass_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 360, 100, 20], 'String', num2str(default_params.mass));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 320, 150, 20], 'String', 'Initial X Position (m)');
    x_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 320, 100, 20], 'String', num2str(default_params.initial_x));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 280, 150, 20], 'String', 'Initial Y Position (m)');
    y_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 280, 100, 20], 'String', num2str(default_params.initial_y));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 240, 150, 20], 'String', 'Initial Velocity X (m/s)');
    vx_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 240, 100, 20], 'String', num2str(default_params.initial_vx));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 200, 150, 20], 'String', 'Initial Velocity Y (m/s)');
    vy_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 200, 100, 20], 'String', num2str(default_params.initial_vy));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 160, 150, 20], 'String', 'Gravity (m/s²)');
    gravity_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 160, 100, 20], 'String', num2str(default_params.gravity));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 120, 150, 20], 'String', 'Air Resistance');
    air_resistance_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 120, 100, 20], 'String', num2str(default_params.air_resistance));
    
    uicontrol(f, 'Style', 'text', 'Position', [20, 80, 150, 20], 'String', 'Restitution');
    restitution_input = uicontrol(f, 'Style', 'edit', 'Position', [180, 80, 100, 20], 'String', num2str(default_params.restitution));
    
    % 実行ボタン
    uicontrol(f, 'Style', 'pushbutton', 'Position', [300, 40, 100, 40], 'String', 'Run Simulation', ...
              'Callback', @(~, ~) run_simulation());

    % シミュレーション実行関数
    function run_simulation()
        % パラメータを取得
        params = struct();
        params.mass = str2double(mass_input.String);
        params.initial_x = str2double(x_input.String);
        params.initial_y = str2double(y_input.String);
        params.initial_vx = str2double(vx_input.String);
        params.initial_vy = str2double(vy_input.String);
        params.gravity = str2double(gravity_input.String);
        params.air_resistance = str2double(air_resistance_input.String);
        params.restitution = str2double(restitution_input.String);

        % シミュレーションを開始
        simulate(params);
    end

    % シミュレーション関数
    function simulate(params)
        % 初期条件
        position = [params.initial_x, params.initial_y];
        velocity = [params.initial_vx, params.initial_vy];
        g = params.gravity;
        air_resistance = params.air_resistance;
        restitution = params.restitution;

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
            gravity = [0, -params.mass * g];                % 重力
            air_drag = -air_resistance * velocity;          % 空気抵抗
            net_force = gravity + air_drag;                 % 合力

            % ニュートンの運動法則
            acceleration = net_force / params.mass;         % 加速度

            % 速度と位置の更新
            velocity = velocity + acceleration * dt;        % 速度更新
            position = position + velocity * dt;            % 位置更新

            % 地面に衝突した場合の処理 (バウンド)
            if position(2) < 0
                position(2) = 0;                            % 地面より下に行かない
                velocity(2) = -velocity(2) * restitution;   % y速度を反転して減衰
                if abs(velocity(2)) < 0.1                  % 速度が非常に小さい場合停止
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
    end
end
