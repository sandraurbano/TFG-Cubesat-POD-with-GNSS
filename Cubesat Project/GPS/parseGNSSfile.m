

function [navmsg,satIDs] = parseGNSSfile(gnssFileType,file)
% Aim: obtain the initial satellite orbital parameters and satellite IDs 
% from the GNSS file, based on the file type.
%
% Input:  --> gnssFileType: 'RINEX', 'SEM', or 'YUCA'
%         --> file: string with the name of the file
%
% Output: --> navmsg: data of the file 
%         --> satIDs: satellite IDs 

    switch gnssFileType
        case "RINEX"
            navmsg = rinexread(file);
            % For RINEX files, extract gps data and use only the first entry for each satellite.
            gpsData = navmsg.GPS;
            [~,idx] = unique(gpsData.SatelliteID);
            navmsg = gpsData(idx,:);
            satIDs = navmsg.SatelliteID;
        case "SEM"
            navmsg = semread(file);
            satIDs = navmsg.PRNNumber;
        case "YUMA"
            navmsg = yumaread(file);
            satIDs = navmsg.PRN;
    end
end