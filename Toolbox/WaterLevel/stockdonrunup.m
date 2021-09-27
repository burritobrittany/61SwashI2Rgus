%% Stockdon et al., 2006 Model

%R2=1.1[0.35Bf(HoLo)^1/2 + {[HoLo(0.563Bf^2 + 0.004]^1/2}/2]
%R2_dissipative=0.043(sqrt(Ho.*Lo))

function [IB setup swash swashIN swashIG R2 R2_dissipative]=stockdonrunup(Ho,T,Bf)

if isequal(size(Ho),size(T),size(Bf))
    
    Lo=9.81./(2*pi).*T.^2;
    IB=Bf./sqrt(Ho./Lo);
    setup=(0.35.*Bf).*sqrt(Ho.*Lo);
    swash=sqrt((Ho.*Lo).*(0.563.*(Bf.^2) + 0.004));
    swashIN=0.75.*Bf.*sqrt(Ho.*Lo);
    swashIG=0.06.*sqrt(Ho.*Lo);
    R2=1.1.*(setup+(swash./2));
    %R2=new_coef.*(setup+(swash./2));
    R2_dissipative=0.043.*sqrt(Ho.*Lo);

else
    disp('Ho, Lo, and Bf must be the same size variables') 
end