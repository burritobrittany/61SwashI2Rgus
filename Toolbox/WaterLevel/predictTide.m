function [eta]= predictTide(cSpeed,sConsts,t,mval,datconv)
%% Function Description
%  Function to predict tide value using tidal constituents. 

%  cSpeed is tidal frequency in deg/hr. Each row is a constituent (Nx1 Rows)
%  sConsts is a Nx2 matrix,first column is amplitude and second in degrees
%  mval is the mean value for whatever datum constituents are defined in
%  datconv is the conversion to the desired datum


eta=sum( 2*sConsts(:,1).*cosd(cSpeed.*24.*t+sConsts(:,2)))+mval+datconv;
end
