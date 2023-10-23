-- Date: 2023-10-13
-- Author: Euan Turner

config.title = "Ramjet Inlet (curved)"
config.dimensions = 2
config.axisymmetric = false

-- Set gas model and flow parameters
setGasModel('ideal-air.gas')

M_inf = 6.42
p_inf = 1354 -- Pa
T_inf = 273.0 -- K (subject to change, currently placeholder)

initial = FlowState:new{p=p_inf, T=T_inf}
inflow = FlowState:new{p=p_inf, T=T_inf, velx=M_inf*initial.a, vely=0.0}

-- Specified ramp coordinates
Ax = 0.0
Ay = 0.454
Bx = 0.988
By = 0.299
Cx = 1.807
Cy = 0.045

Dx = 2 --free parameter (can be chosen)

-- bottom edge
a = Vector3:new{x=Ax, y=0.0}
b = Vector3:new{x=Cx, y=0.0}
c = Vector3:new{x=Dx, y=0.0}

--top edge
d = Vector3:new{x=Dx, y=Cy}
e = Vector3:new{x=Cx, y=Cy}
f = Vector3:new{x=Ax, y=Ay}

-- bezier control point 
b1 = Vector3:new{x=Bx, y=By} -- free paramter

--First geometry block
af = Line:new{p0=a, p1=f}
be = Line:new{p0=b, p1=e}
ab = Line:new{p0=a, p1=b} --left to right across
fe = Bezier:new{points={f, b1, e}} --bottom to top upward

--Second geometry block repeat for west
ed = Line:new{p0=e, p1=d}
bc = Line:new{p0=b, p1=c}
cd = Line:new{p0=c, p1=d}

patch = {}
patch[0] = CoonsPatch:new{
    north=fe, east=be,
    south=ab, west=af
}
patch[1] = CoonsPatch:new{
    north=ed, east=cd,
    south=bc, west=be
}

grid={}
grid[0] = StructuredGrid:new{psurface=patch[0], niv=81, njv=41}
grid[1] = StructuredGrid:new{psurface=patch[1], niv=81, njv=41}

blk0 = FluidBlock:new{grid=grid[0], initialState=inflow,
                        bcList={west=InFlowBC_Supersonic:new{flowState=inflow}}    
}
blk2 = FluidBlock:new{grid=grid[1], initialState=inflow,
                        bcList={east=OutFlowBC_Simple:new{}}    
} 
identifyBlockConnections() -- internal connections dealt with

-- set solver settings (preliminary)
config.max_time = 5.0e-3 -- s
config.max_step = 100000
config.cfl_value = 0.5
config.dt_init = 1.0e-6 
config.flux_calculator = "ausmdv"
config.dt_plot = config.max_time/100 --100 frames?
config.dt_history = 1.0e-5

setHistoryPoint{x=f.x, y=f.y} --at the inflow wall top left
setHistoryPoint{x=d.x, y=d.y} --at the outflow wall top
setHistoryPoint{x=e.x+(d.x - e.x)/2, y=e.y/2} -- capture the pressure inside of the throat