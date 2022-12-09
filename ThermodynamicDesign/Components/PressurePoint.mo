within ThermodynamicDesign.Components;

model PressurePoint

  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;
 
  parameter SI.AbsolutePressure p_set;
   
  SI.SpecificEnthalpy h "Enthalpy";
  SI.AbsolutePressure p "Pressure";
  
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  port_a.m_flow + port_b.m_flow = 0;
  h = inStream(port_a.h_outflow);
  h = port_b.h_outflow;
  port_a.h_outflow = port_b.h_outflow;
  port_a.p = p;
  port_b.p = p;
  p = p_set;
  

annotation(
    Icon(graphics = {Rectangle(fillColor = {51, 13, 238}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-40, 40}, {40, -40}})}));
end PressurePoint;
