%=========================================================================%
% Function: [prol, grar, sene, apop, times] = model_fun(result, state_num,end_time)
% Created by: Daniel Galvis, Darren Walsh, James Rankin
% This function takes in a parameter set, number of proliferative states,
% and a length (in hours) to run the simulation
% Inputs:
%   - result - parameters, usually taken from one of the files or derived
%     from the optimizer (parameters_etc.mat)
%   - state_num - the number of proliferative states, also derived from the
%     parameter files (parameters_etc.mat)
%   - end_time - the last time point (in hours, usually 5000)
%
% Outpus:
%   - prol - fraction of proliferative cells
%   - grar - fraction of growth-arrested cells
%   - sene - fraction of senescent cells
%   - apop - fraction of apoptotic cells
%   - times - time points (in hours
%=========================================================================%
function [prol, grar, sene, apop, times, PD] = model_fun(result,state_num,end_time)
%=========================================================================%
% Initiate parameters for optimiser
%=========================================================================%
    LeftPP = result(1);
    RightPP = result(2);
    LeftPG =   result(3); 
    RightPG = result(4);
    GS =  result(5);
    LeftPA = result(6);
    RightPA =  result(7);
    LeftPS = result(8);
    RightPS =result(9);
    AD =  result(10);


    param.state_num = state_num;        
    param.PP = linspace(LeftPP,RightPP,param.state_num); % division rate
    param.PG = linspace(LeftPG,RightPG,param.state_num); % movement into quiescence
    param.GS = GS; % jump to senescence (from quiescence)
    param.PA = linspace(LeftPA,RightPA,param.state_num); % movement into apoptosis/necrosis
    param.PS = linspace(LeftPS,RightPS,param.state_num); % jump to senescence (from proliferative states)
    param.AD = AD; % movement to death from apoptosis/necrosis
         
       

%=========================================================================%
% % Run the Dynamical System
%=========================================================================%
        
    init_cell_num = 150; % in thousands
    initial_values = zeros(1,param.state_num + 3); 
                              % states are proliferative populations, then
                              % the other 3 populations are senescent,
                              % quiescent, and necrotic/apoptotic cells.
                              
    initial_values(end) = 0*init_cell_num;
    initial_values(end-2) = 0*init_cell_num;
    initial_values(end-1) = 0*init_cell_num;
    initial_values(1) = 1*init_cell_num;
                              % for now, we assume that all cells are initially
                              % in the proliferative state. We may be able to
                              % improve the model if we have senescence markers
                              % prior to the first passage.

        
    clear t y x;
     %solve ODE
     [t, y] = ode45(@(t, x) ode_system(t, x, param), ...      %solve ODE
                        [0 end_time],initial_values);  
                        
%=========================================================================%
% % Separate the ODE result into populations
%=========================================================================%                        
        
        if(size(y,1)==length(t))
            y = y';
        end       
        % Total numbers of all populations
        prol=sum(y(1:param.state_num,:),1) ;
        sene=y(param.state_num+1,:);
        grar=y(param.state_num+2,:);
        apop=y(param.state_num+3,:); 
        total_pop = sum(y,1);
        % Fractions of all populations
        prol = prol./total_pop;
        sene = sene./total_pop;
        grar = grar./total_pop;
        apop = apop./total_pop;
        pts = 10000;
        % Interpolate for an even number of time points
        prol = interp1(t,prol,linspace(0,end_time,pts));
        sene = interp1(t,sene,linspace(0,end_time,pts));
        grar = interp1(t,grar,linspace(0,end_time,pts));
        apop = interp1(t,apop,linspace(0,end_time,pts));
        total_pop = interp1(t,total_pop,linspace(0,end_time,pts));
        times = linspace(0,end_time,pts);
        
        % Number of population doublings over times
        PD = log(total_pop/sum(initial_values))/log(2);
end
      
