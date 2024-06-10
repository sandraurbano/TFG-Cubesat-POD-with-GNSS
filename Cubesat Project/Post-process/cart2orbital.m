function [a,norm_e,i,omega,w,nu] = cart2orbital(r,v,mu)
% Aim: Transform cartesian elements into keplerian elemenets 
%
% INPUT  --> r: vector with position cordinates [m]
%            v: vector with velocity cordinates [m/s]
%            mu: gravitational parameter of the central body [m/s^2]
% OUTPUT --> a: semi-mayor axis [m]
%            norm_e: eccentricity magnitude [-] 
%            i: inclination [deg]
%            omega: longitude of ascending node [deg]
%            w: argument of perigee [deg]
%            nu: true anomaly [deg]

   % Define unit vectors
    unit_x = [1 0 0];
    unit_y = [0 1 0];
    unit_z = [0 0 1];

    norm_r = norm(r);
    norm_v = norm(v);
    
    h = cross(r,v);
    norm_h = norm(h);
    
    % Semi-mayor axis: a
    a = -mu/2*(norm_v^2/2-mu/norm_r)^(-1);
    
    % Eccentricity: e
    e = 1/mu*((norm_v^2-mu/norm_r)*r-dot(r,v)*v);
    norm_e = norm(e);
    
    % Inclination: i
    i = acosd(dot(h,unit_z)/norm_h);
    
    % Longitude of ascending node: omega
    n = cross(unit_z,h); % vector pointing towards of the ascending node
    norm_n = norm(cross(unit_z,h));
    unit_n = n/norm_n;  
    omega = acosd(dot(unit_n,unit_x));

    % Quadrant check
    if (dot(unit_n,unit_y)<0)
        omega = 360-omega;
    end  
    
    % Argument of periapsis: w
    w = acosd(dot(unit_n,e)/norm_e);

    % Quadrant check
    if (dot(unit_z,e)<0)
        w = 360-w;
    end  

    % True anomaly: nu
    nu = acosd(dot(e,r)/(norm_e*norm_r));

    % Quadrant check
    
    if (dot(r,v)<0)
        nu = 360-nu;
    end  

end