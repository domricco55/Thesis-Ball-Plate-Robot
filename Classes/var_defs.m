classdef Var_Defs
    %This class defines symbolic variables, generally, for use with the symbolic
    %toolbox throughout the Ball and Plate thesis project. 
    %   Defines symvars and symfuns for scalars, vectors, and matrices. The
    %   definitions are kept as general as possible and do not contain any
    %   non-fundamental derived results. 
    
    properties 
    %Scalars
        %Miscellaneous
        t %time symbolic variable
        g %gravitational constant symbolic variable
        
        %Angle Variables
        beta_hat
        gamma_hat 
        theta_hat_3 
        theta_hat_4 
        theta_hat_5 
        theta_hat_6 
        theta_hat_7
        theta_hat_8
        
        %Angular Velocities for Omega Vectors/Matrices
        
        %Length Related System Parameters
        w %width of plate
        z_Pc %Vertical distance from u-joint to push rod pivot (Pc is "point c")
        z_p %height of the plate's center of mass with respect to the frame's 
            %origin at the center of the u-joint    
        L_carm %length of motor mechanism crank arm
        L_crod %length of motor mechanism connecting rod
        
        %Variables Related to Mass and Geometry of the Ball
        I_b %mass moment of inertia of the ball (spherically symmetric)
        I_p_xx %x direction mass moment of inertia of plate (principle axis)
        I_pyy %y direction mass moment of inertia of plate (principle axis)
        I_pzz %z direction mass moment of inertia of plate (principle axis)
        m_b %mass of the ball
        m_p %mass of the plate
        r_b %radius of the ball
        
        %Coordinate of the Ball's Center of Mass in the S2 (plate) Frame  
        x_hat   %x location of ball in plate frame (symfun)        
        y_hat   %y location of ball in plate frame (symfun)        
        z_b     %constant distance from the center of the u-joint to 
                %the C.O.M of the ball (symvar)                
        ix      %time integral of x location of the ball in the plate frame 
                %(symvar)                
        x       %like x_hat but a symvar        
        y       %like y_hat but a symvar 
        x_dot   %time rate of change of x (symvar)
        y_dot   %time rate of change of y (symvar)
        x_ddot  %time rate of change of x_dot (symvar)
        y_ddot  %time rate of change of y_dot (symvar)
        
        %Arbitrary displacment vector in S2
        r_hat_1 %arbitrary displacement vector component 1 (symfun) 
        r_hat_2 %arbitrary displacement vector component 2 (symfun)
        r_hat_3 %arbitrary displacement vector component 3 (symfun)
        r_1     %arbitrary displacement vector component 1 (symvar)
        r_2     %arbitrary displacement vector component 2 (symvar)
        r_3     %arbitrary displacement vector component 3 (symvar) 
        r_dot_1 %time rate of change of r_1 (symvar)
        r_dot_2 %time rate of change of r_2 (symvar)
        r_dot_3 %time rate of change of r_3 (symvar)    
        r_ddot_1%time rate of change of r_dot_1 (symvar)       
        r_ddot_2%time rate of change of r_dot_2 (symvar)   
        r_ddot_3%time rate of change of r_dot_3 (symvar) 
        
        %U-Joint Axle Torques and Reactions
        T_beta  %Torque about beta axis of u-joint (symvar)
        T_gamma %Torque about gamma axis of u-joint (symvar)
        M_z     %Reaction moment supplied by u-joint in its z-direction (symvar)
        
        %Error States and Setpoints (x and y Variables)
        e_x     %error in x (symvar)   
        e_x_dot %error in x_dot (symvar)   
        e_x_ddot%error in x_ddot (symvar) 
        e_ix    %error in the integral of x (symvar) 
        ix_s    %integral of the x setpoint - time integral of desired
                %x trajectory (symvar)
        x_s     %x setpoint - desired x trajectory (symvar)
        x_dot_s %x_dot setpoint - velocity of desired x trajectory (symvar)
        x_ddot_s%x_ddot setpoint - acceleration of desired x trajectory (symvar) 
        
    %Vectors
    
    %Matrices
    
    %State Space Model - Related
    
    %
    end
    
    properties (SetAccess = private)
        
    end 
    
    methods
        function obj = Var_Defs()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

