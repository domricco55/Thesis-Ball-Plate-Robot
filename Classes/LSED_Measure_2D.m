classdef LSED_Measure_2D < handle
    %LSED_Measure_2D  Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        
        %Computed in the constructor
        t_samp %resampled time points
        resamp_rspnse %resampled controller response (position of ball)
        resamp_stpt %resampled setpoint (desired position of ball)
        
        %Computed LSED results
        LSED
        
        %y axis label
        ylabel_str
    end
    
    methods
        function obj = LSED_Measure_2D(samp_f, response, setpoint, tsim, ylabel_str, plot_cmd)
            %LSED_Measure Construct an instance of this class
            %   response is a matrix of two column vectors, the first being the x location
            %   of the ball at each point in time and the second being the y location of
            %   the ball. Setpoint is the same but for the setpoints in x and y. 
            
            %Object's y axis label (what is the trajectory we are talking about?)
            obj.ylabel_str = ylabel_str;
            
            %Control Output Resample
            obj.t_samp = linspace(tsim(1), tsim(end), samp_f*(tsim(end) - tsim(1)));  
            obj.resamp_rspnse = interp1(tsim,response, obj.t_samp);

            %Setpoint Resample
            %This will have sample frequency of samp_f
            obj.resamp_stpt = interp1(tsim, setpoint, obj.t_samp);

            %If the plot_cmd is true, plot the resampled signals
            if plot_cmd

                figure
                plot(obj.t_samp, obj.resamp_rspnse,obj.t_samp,obj.resamp_stpt)
                xlabel('time [s]')
                ylabel(obj.ylabel_str)
                title('Resampled Controller Data')
                legend('Controller Output', 'Reference')

            end   
            
        end
        
        function [LSED]  = Get_LSED_Measure(obj)
            %Get_LSED_Measure Get the LSED distance measure. 
            %Get the LSED distance measure for the resampled data

            n = length(obj.resamp_rspnse;

            sq_errs = (obj.resamp_rspnse - obj.resamp_rspnse).^2; %x and y errors squared

            eucl_dist = sqrt(sq_errs(:,1) + sq_errs(:,2)); %Euclidean distance at each point in time

            LSED = 1/n*sum(eucl_dist); %Normalized sum of the Euclidean distances at each point in time
            
            dtw(obj.resamp_rspnse, obj.resamp_stpt, 'absolute');
            
            obj.LSED = LSED;
            
            end
            
        end        
        
    end
end

