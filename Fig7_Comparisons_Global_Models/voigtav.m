function [ Vs_vt ] = voigtav( Vsh,Vsv)
%[ Vs_av, Vp_av ] = voigtav( Vsh,Vsv,Vph,Vpv,eta )
%   Calculate Voigt average velocities from vertically and horizontally
%   polarised wavespeeds, plus eta...


Vs_vt = sqrt( (  Vsh.^2 + 2*Vsv.^2)/3 );


end

