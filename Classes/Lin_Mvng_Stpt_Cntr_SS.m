classdef Lin_Mvng_Stpt_Cntr_SS < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        
        sys_mats %System Matrices
        sim_response %Latest system response for this object
    end
    
    
    methods
        function obj = Lin_Mvng_Stpt_Cntr_SS(Lnrzed_EOMs,type)
            %Lin_Mvng_Stpt_Cntr_SS Construct an instance of this class
            %   Detailed explanation goes here
            
            switch type
                
                case 'SS Integral Controller'
                    
                    %Augmented A Matrix
                    obj.sys_mats.Aa = [zeros(5,1),[-1 0 0 0; Lnrzed_EOMs.A1]]; 
                    
                    %Augmented B Matrix
                    obj.sys_mats.Ba = [0;Lnrzed_EOMs.B1];
                    
                    %S matrix, the setpoint matrix
                    obj.sys_mats.S = sym([1;0;0;0;0]);
                    
                    %Our desired control output is the x state (want it to match as 
                    %closely as possible to x_s for all times). C and D select the x state
                    %from the augmented state vector
                    obj.sys_mats.C = sym([0 1 0 0 0]); 
                    obj.sys_mats.D = 0;  
                    
                    %x setpoint selector matrix (plotting in Simulink purposes)
                    obj.sys_mats.x_s_select = 1;
                case 'SS PID Controller'    
                    
                otherwise
                    error('Not a valid moving setpoint controller type')
                    
            end 
        end
        
        
        function [] = Run_Sim(obj,setpoint_symfun, tspan, xa_0, K)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
         
            
            %Set the Simulink Parameters (Matrices, times, gains, etc.)
        
                %Timespan
                tspan = Simulink.Parameter(tspan);
                assignin('base', 'tspan', tspan)

                %ICs
                xa_0 = Simulink.Parameter(xa_0);
                assignin('base', 'xa_0', xa_0);

                %Symbolic matrices derived or assigned in the constructor
                Aa = Simulink.Parameter(double(obj.sys_mats.Aa));
                assignin('base', 'Aa', Aa); %Create the simulink paramter in the base workspace 
                Ba = Simulink.Parameter(double(obj.sys_mats.Ba));
                assignin('base', 'Ba', Ba); %Create the simulink paramter in the base workspace 
                S = Simulink.Parameter(double(obj.sys_mats.S));
                assignin('base', 'S', S); %Create the simulink paramter in the base workspace 
                C = Simulink.Parameter(double(obj.sys_mats.C));
                assignin('base', 'C', C); %Create the simulink paramter in the base workspace 
                D = Simulink.Parameter(double(obj.sys_mats.D));
                assignin('base', 'D', D); %Create the simulink paramter in the base workspace 
                x_s_select = Simulink.Parameter(obj.sys_mats.x_s_select);
                assignin('base', 'x_s_select', x_s_select); %Create the simulink paramter in the base workspace         

                %Gain matrix K
                K = Simulink.Parameter(K);
                assignin('base', 'K', K); %Create the simulink paramter in the base workspace   
            
            %Replace the definition of the "Input_Function" MATLAB function block with the
            %setpoint_symfun input
                matlabFunctionBlock('Linear_Moving_Setpoint_SS/Input_Function', setpoint_symfun)
            
            %Run the simulation    
                obj.sim_response = sim('Linear_Moving_Setpoint_SS');
            
        end
        
%         function [] = plot_results(obj)
%             %METHOD2 Summary of this method goes here
%             %   Detailed explanation goes here 
%         end 
%         
%         function [] = create_animation(obj)
%             %METHOD3 Summary of this method goes here
%             %   Detailed explanation goes here
%         end 
        
    end
end

