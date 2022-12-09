within ThermodynamicDesign.Components;

model LoopBreaker

  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.h_outflow = port_b.h_outflow;
  port_a.p = port_b.p;
  
assert(port_a.m_flow + port_b.m_flow == 0, "Invalid mass flows");  

annotation(
    Icon(graphics = {Rectangle(fillColor = {154, 162, 165}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-40, 40}, {40, -40}}), Line(points = {{0, 40}, {-18, 10}, {18, -10}, {0, -40}, {0, -40}}, thickness = 1)}));
end LoopBreaker;
