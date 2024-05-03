function skyplot(spirent,Type)

    indices_gps = strcmp(spirent.satData.Sat_type, Type);
    maxChannels = max(spirent.satData.Channel);
    maxGPS = sum(indices_gps(1:maxChannels));
    spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);
    
    
    satellite_data = cell(maxGPS, 1); % Inicializar la celda
    
    for i = 1:maxGPS
        idx = find(spirent.satData.Channel == i);
        size_idx = length(idx);
        
        % Crear la estructura para este satélite
        satellite_struct = struct();
        
        % Inicializar vectores de tiempo, azimuth y elevación
        t = zeros(size_idx, 1);
        Az = zeros(size_idx, 1);
        El = zeros(size_idx, 1);
        PRN = zeros(size_idx, 1);
        
        % Asignar los valores de tiempo, azimuth y elevación
        for j = 1:size_idx
            t(j) = spirent.satData.Time_ms(idx(j));
            Az(j) = spirent.satData.Azimuth(idx(j));
            El(j) = spirent.satData.Elevation(idx(j));
            PRN(j) = spirent.satData.Sat_PRN(idx(j));

            if El(j)<0 
                El(j) = El(j) + 2*pi;
            end 
        end
        
        % Asignar los vectores a la estructura del satélite
        satellite_struct.time = t;
        satellite_struct.azimuth = Az;
        satellite_struct.elevation = El;
        satellite_struct.PRN = PRN;
        
        % Asignar la estructura a la celda
        satellite_data{i} = satellite_struct;
    end

     % Create a new figure
    figure;
    title('GPS Satellite Skyplot');
    grid on;

    % Plot circles representing elevation angles
    % for angle = 10:20:90
    %     polarplot(deg2rad([0 360]), ones(1, 2)*deg2rad(angle), 'color', [0.22 0.22 0.22]);
    %     hold on;
    % end



    % Plot satellite trajectories
    for sat_id = 1:length(satellite_data)
        azimuth = satellite_data{sat_id}.azimuth;
        elevation = satellite_data{sat_id}.elevation;

        % Plot trajectory
        polarplot(azimuth, elevation,'Color',"#0072BD");
        hold on
        polarscatter(azimuth(end),elevation(end),150,'MarkerFaceColor','#0072BD',...
            'MarkerEdgeColor','#0072BD','MarkerFaceAlpha',0.5);
        text(azimuth(end),elevation(end)-0.1,num2str(spirent.satData.Sat_PRN(sat_id)),...
            'HorizontalAlignment', 'center','Color','k');
        hold on;
            
    end
end

