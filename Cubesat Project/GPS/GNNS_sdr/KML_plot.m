function KML_plot(KML_file)
% Aim: Creates a KML plot
% INPUT  --> KML_file: path of the KML file
% OUTPUT --> figure

T = readgeotable(KML_file);
wmmarker(T)

end

