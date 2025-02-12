classdef UJ_Knmtcs < handle
    %UJ_Knmtcs This class generates the ... 
    %   Detailed explanation goes here
    
    properties

    end
   
    properties (SetAccess = private)
        VDefs 
        r0s
        Omega2ms
        Omega2vs
        v2s
        a2s
    end 
    
    methods
        function obj = UJ_Knmtcs(Var_Defs)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            
            
            %Assign the Var_Defs object that was in the constructor argument to the
            %classes VDefs property
            obj.VDefs = Var_Defs;          
           

        end
        
        
        function r0s = derive_pos(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here 
            
            %Derive r0s, the arbitrary displacement vector originally defined in frame S2,
            %rotated into the S0 basis
            obj.r0s = obj.VDefs.R20*obj.VDefs.r2s;
            
            %Return output
            r0s = obj.r0s; %Methods must return something in MATLAB. 
            
        end 
        
        function [Theta_d_gam,Theta_d_beta,Omega2ms, Omega2vs, v2s] = derive_vel(obj)  
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            
            
            
            %Get the Theta_d_gam matrix by multiplying R12d by R21. R12d = Theta_D_gam*R12
            %and therefore R21 anihilates with R12.  
            Theta_d_gam = simplify(obj.VDefs.R12d*obj.VDefs.R21); %shows that if this is Theta_d_12 then Theta_d_12*R12 = R12d
            
            %Get the Theta_d_beta matrix by multiplying R01d by R10. R01d =
            %Theta_D_gam*R01 and therefore R10 anihilates with R01.  
            Theta_d_beta = simplify(obj.VDefs.R01d*obj.VDefs.R10);
            
            %Derive the global angular velocity matrix of the plate frame in terms of beta
            %and gamma. This matrix has components expresseed in the S2 basis, the plate
            %frame. 
            obj.Omega2ms = simplify((Theta_d_gam + obj.VDefs.R12*Theta_d_beta*obj.VDefs.R21).');
            
            %Extract the components of Omega2ms associated with Omega2vs, the vector
            %representation of the same information. 
            obj.Omega2vs = obj.VDefs.Omega2vs; %This makes a copy of the variable defined in VDefs.
            %This class will utilize the definition but create and alter its own copy of the variable. 
            obj.Omega2vs(1) = obj.Omega2ms(3,2); 
            obj.Omega2vs(2) = obj.Omega2ms(1,3);
            obj.Omega2vs(3) = obj.Omega2ms(2,1);
            
            %Derive the global velocity vector of an arbitrary displacement within frame
            %S2 written in the S2 basis. 
            obj.v2s =  diff(obj.VDefs.r2s,obj.VDefs.t) + obj.Omega2ms*obj.VDefs.r2s; 
            
            %Return the outputs
            Omega2ms = obj.Omega2ms;
            Omega2vs = obj.Omega2vs;
            v2s = obj.v2s;
            
        end
        
        function [a0s, a2s] = derive_acc(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here 
            
            
            %Derive the global acceleration vector of an arbitrary displacement within frame
            %S2 written in the S2 basis. 
            a0s = diff(obj.VDefs.R20*obj.v2s,obj.VDefs.t);
            obj.a2s = simplify(obj.VDefs.R02*a0s);
            
            %Return the outputs
            a2s = obj.a2s;
            
        end
        
        function [r0s, Theta_d_gam,Theta_d_beta,Omega2ms, Omega2vs, v2s,a0s, a2s] = derive_all(obj)
            
            r0s = obj.derive_pos;
            [Theta_d_gam,Theta_d_beta,Omega2ms, Omega2vs, v2s] = obj.derive_vel;
            [a0s, a2s] = obj.derive_acc;
            
        end
        
    end
end

