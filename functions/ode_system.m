%-------------------------------------------------------------------------
% Definition of the ODE system
%-------------------------------------------------------------------------
function deriv = ode_system (t, x, param)
% Function to calculate derivatives of the senescence index model
%
% Input:
%       t:     Time (no explicit time dependence).
%       x:     Vector of the current values of all variables in the same
%              order as you defined the inital values:
%       param: Used to pass parameter values.
% Output:
%       deriv: Column vector of derivatives, must be the same order as the
%              input vector x.
                                   
x = x';
% Indexing for equations
prol_skipfirst_idx = 2:(param.state_num);                                       %prolferating population - initial pop
prol_idx = 1:(param.state_num);                                       %all proliferating populations
prol_upto_idx = 1:(param.state_num-1);                                     %proliferating populations - final proliferating pop
grar_idx = param.state_num + 2;                                       %growth arrested populations
apop_idx = param.state_num + 3;                                       %apoptotic populations

% EQUATIONS
 %initial pop
dprol1 = -param.PP(1) * x(1) - param.PG(1) * x(1) - param.PS(1) * x(1)...
      - param.PA(1) * x(1); 
 
%proliferating
dprol = -param.PP(prol_skipfirst_idx) .* x(prol_skipfirst_idx) + 2 * param.PP(prol_upto_idx) .* x(prol_upto_idx)...
     - param.PG(prol_skipfirst_idx) .* x(prol_skipfirst_idx) - param.PS(prol_skipfirst_idx) .* x(prol_skipfirst_idx)...
     - param.PA(prol_skipfirst_idx) .* x(prol_skipfirst_idx);    
   
%senescent pop 
dsene = +2 * param.PP(param.state_num-1) * x(param.state_num-1) ...
    + sum(param.PS(prol_idx).* x(prol_idx))+ param.GS * x(grar_idx);                                      
 
%growth arrested pop
dgrar = +sum(param.PG(prol_idx) .* x(prol_idx)) - param.GS * x(grar_idx); 
 
%apoptotic cells
dapop = +sum(param.PA(prol_idx) .* x(prol_idx)) - param.AD*x(apop_idx);  
 
% %number of cells jumping to senescence
deriv = [dprol1,dprol,dsene,dgrar,dapop]';

end 