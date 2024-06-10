function utcDatetime = gps2utc(gpsWeek, rx_time)
% Aim: Transform GPS time to UTC
%
% INPUT  --> gpsWeek: GPS Time of the week (TOW)
%            rx_time: GPS receiving time
% OUTPUT --> utcDatetime: UTC time   

    % GPS epoch
    gpsEpoch = datetime(1980, 1, 6, 0, 0, 0, 'TimeZone', 'UTC');
    
    % Seconds in a week
    daysInWeek = 7;
    secondsInWeek = daysInWeek * 24 * 60 * 60;
    
    % Total seconds from GPS epoch to the given GPS week
    totalWeekSeconds = double(gpsWeek * secondsInWeek);
    
    % Calculate the total seconds since GPS epoch to the RX_time
    totalSeconds = totalWeekSeconds + rx_time;
    
    % Convert total seconds to duration
    gpsDuration = seconds(totalSeconds);
    
    % Add the duration to the GPS epoch to get the UTC datetime
    utcDatetime = gpsEpoch + gpsDuration;
end
