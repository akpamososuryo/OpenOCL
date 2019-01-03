classdef CasadiVariable < Variable
  
  properties
    mx
  end
  
  methods (Static)
    
    function var = create(type,mx,value)
      if isa(type,'OclTree')
        names = fieldnames(type.children);
        id = [names{:}];
      else
        id = class(type);
      end
      
      [N,M,K] = size(type);
      assert(K==1,'Not supported.');
      if N*M*K==0
        vv = [];
      elseif mx == true
        vv = casadi.MX.sym(id,N,M);
      else
        vv = casadi.SX.sym(id,N,M);
      end
      val = OclValue(vv);
      p = reshape(1:N*M*K,N,M,K);
      var = CasadiVariable(type,p,mx,val);
      if nargin==3
        var.set(value);
      end
    end
    
    function obj = Matrix(size,mx)
      if nargin==1
        mx = false;
      end
      obj = CasadiVariable.create(OclMatrix(size),mx);
    end
    
    function obj = createLike(input,mx)
      obj = CasadiVariable.create(input.type,mx);
    end
    
    function obj = createLikeSameType(input,val)
      ismx = isa(val,'casadi.MX');
      obj = CasadiVariable.create(input,ismx,val);
    end
    
  end
  
  methods
    
    function self = CasadiVariable(type,positions,mx,val)
      % CasadiVariable(type,positions,mx,val)
      narginchk(4,4);      
      self = self@Variable(type,positions,val);
      self.mx = mx;      
    end
  end
    
  methods (Access = protected)
    function r = disp(self)
      r = sprintf(['Value: ', self.value.str(), '\n',...
                   'Type: ', class(self.type)]);
    end
  end
end
