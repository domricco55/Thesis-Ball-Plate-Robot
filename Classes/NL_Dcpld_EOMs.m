classdef NL_Dcpld_EOMs <handle
    %NL_Dcpld_EOMs This class produces a symbolic, nonlinear, decoupled model for the ball
    %and plate system. The class developement script
    %"Nonlinear_Decoupled_EOMS_Class_Dev.mlx" serves as a detailed documentation of the
    %workings of this class. 

    properties (SetAccess = private)
        %Ball Plate System Objects
        VDefs
        BP_Kinetics

        %x-axis results
        SumMBall_x
        SumMBallPlate_x
        SolvedEOMs_x
        g_1
        f_1

        %x-axis results
        SumMBall_y
        SumMBallPlate_y
        SolvedEOMs_y
        g_2
        f_2

        %Total decoupled system
        f
        g
        DcpldEOMs
        
        %Numerical EOMs
        NumDcpldEOMs
        Num_g_1
        Num_f_1
        Num_g_2
        Num_f_2
        Num_SumMBall_x
        Num_SumMBall_y

    end

    methods
        function obj = NL_Dcpld_EOMs(VDefs, BP_Kinetics)
            %NL_Dcpld_EOMs Construct an instance of this class
            %   Derive the nonlinear decoupled equations of motion for the sytem starting
            %   from the full nonlinear model. Make the decoupling assumptions discussed
            %   in the "Nonlinear_Decoupled_EOMS_Class_Dev.mlx" class developement script.  

            %Assign the inputs to the constructor to the class properties
            obj.VDefs = VDefs;          
            obj.BP_Kinetics = BP_Kinetics;

            %Decouple the x axis

            %Ball Kinetics x direction
            obj.SumMBall_x = subs(obj.BP_Kinetics.SumMBall(2),[obj.VDefs.gamma obj.VDefs.gamma_dot obj.VDefs.gamma_ddot ], [0 0 0]);
            
            %Ball and Plate Kinetics x direction
            obj.SumMBallPlate_x = subs(obj.BP_Kinetics.SumMBallPlate(2),[obj.VDefs.gamma obj.VDefs.gamma_dot obj.VDefs.gamma_ddot], [0 0 0]);

            %Bring Together Nonlinear Decoupled Moment Equations and Solve for Highest Order Terms
            EOMS_x = [obj.SumMBall_x;obj.SumMBallPlate_x];
            [CoeffMat_x,ExtTerms_x] = equationsToMatrix(EOMS_x , [obj.VDefs.x_ddot, obj.VDefs.beta_ddot]); 
            obj.SolvedEOMs_x = obj.VDefs.stateVec1_dot == [obj.VDefs.x_dot; [1 0]*(CoeffMat_x\ExtTerms_x); obj.VDefs.beta_dot;[0 1]*(CoeffMat_x\ExtTerms_x)];

            %Find input matrix g(x) x direction
            [obj.g_1,g_1_extra_terms] = equationsToMatrix(obj.SolvedEOMs_x , obj.VDefs.T_beta);
            obj.g_1 = -obj.g_1;
            g_1_extra_terms = -g_1_extra_terms;
            
            obj.f_1 = - g_1_extra_terms + obj.VDefs.stateVec1_dot;


            %Decouple the y axis

            %Ball Kinetics y direction
            obj.SumMBall_y = subs(obj.BP_Kinetics.SumMBall(1),[obj.VDefs.beta obj.VDefs.beta_dot obj.VDefs.beta_ddot ], [0 0 0]);
            
            %Plate Kinetics y direction
            obj.SumMBallPlate_y = subs(obj.BP_Kinetics.SumMBallPlate(1),[obj.VDefs.beta obj.VDefs.beta_dot obj.VDefs.beta_ddot ], [0 0 0]);

            %Bring Together Nonlinear Decoupled Moment Equations and Solve for Highest Order Terms
            EOMS_y = simplify([obj.SumMBall_y;obj.SumMBallPlate_y]);
            [CoeffMat_y,ExtTerms_y] = equationsToMatrix(EOMS_y , [obj.VDefs.y_ddot, obj.VDefs.gamma_ddot]); 
            obj.SolvedEOMs_y = obj.VDefs.stateVec2_dot == [obj.VDefs.y_dot; [1 0]*(CoeffMat_y\ExtTerms_y); obj.VDefs.gamma_dot;[0 1]*(CoeffMat_y\ExtTerms_y)];


            %Find input matrix g(y) y direction
            [obj.g_2,g_2_extra_terms] = equationsToMatrix(obj.SolvedEOMs_y , obj.VDefs.T_gamma);
            obj.g_2 = -obj.g_2;
            g_2_extra_terms = -g_2_extra_terms;
            
            obj.f_2 = - g_2_extra_terms + obj.VDefs.stateVec2_dot;

            %Total Decoupled System
            obj.f = [obj.f_1;obj.f_2];
            obj.g = [obj.g_1,zeros(size(obj.g_1));zeros(size(obj.g_1)),obj.g_2];
            obj.DcpldEOMs = obj.VDefs.stateVec_dot == obj.f + obj.g*obj.VDefs.inputVec;    


        end

        function [] = Num_Params(obj)
        %Num_Params Input estimated numerical parameters of the system
            %   Replace every symbolic parameter with its numerical counterpart in the
            %   physical system

            %Numerical Parameters in terms of symbolic variables utilized in 
            %the model 
            Num_Params = [obj.VDefs.rB (obj.VDefs.rC+obj.VDefs.rB) ...
            obj.VDefs.mB obj.VDefs.mP obj.VDefs.IP obj.VDefs.IB ...
            obj.VDefs.g_num obj.VDefs.rG];
        
            Sym_Params = [obj.VDefs.r_b obj.VDefs.z_b obj.VDefs.m_b...
                obj.VDefs.m_p obj.VDefs.I_p_xx obj.VDefs.I_b obj.VDefs.g...
                obj.VDefs.z_p];
            
            
            %Substitute in all numerical parameters and assumptions
            obj.NumDcpldEOMs = subs(obj.DcpldEOMs, Sym_Params, Num_Params );
            obj.Num_g_1 = subs(obj.g_1, Sym_Params, Num_Params );
            obj.Num_f_1 = subs(obj.f_1, Sym_Params, Num_Params );
            obj.Num_g_2 = subs(obj.g_2, Sym_Params, Num_Params );
            obj.Num_f_2 = subs(obj.f_2, Sym_Params, Num_Params );
            obj.Num_SumMBall_x = subs(obj.SumMBall_x, Sym_Params, Num_Params);
            obj.Num_SumMBall_y = subs(obj.SumMBall_y, Sym_Params, Num_Params);
        end
    end
end