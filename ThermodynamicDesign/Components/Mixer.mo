within ThermodynamicDesign.Components;

model Mixer

  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;
  
  Modelica.Fluid.Interfaces.FluidPort_a port_in_1(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_in_2(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  port_in_1.p = port_out.p;
  port_in_2.p = port_out.p;
  
  (-port_out.m_flow*port_out.h_outflow) = port_in_1.m_flow*inStream(port_in_1.h_outflow) + port_in_2.m_flow*inStream(port_in_2.h_outflow);
  port_out.m_flow + port_in_1.m_flow + port_in_2.m_flow = 0;
  
  port_in_1.h_outflow = 0;
  port_in_2.h_outflow = 0;

annotation(
    Icon(graphics = {Polygon(origin = {10, 0}, rotation = 180, fillColor = {255, 170, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, points = {{-50, 20}, {-50, -20}, {-20, -20}, {50, -60}, {50, 60}, {-20, 20}, {-50, 20}, {-50, 20}}), Line(origin = {-9.18167, 0}, points = {{-30, 0}, {30, 0}, {30, 0}}, thickness = 1.5), Polygon(origin = {-10, 160}, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {-10, 160}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(origin = {-11.318, -9.83784}, rotation = 180, points = {{25, -85}, {-60, -85}}, color = {0, 128, 255})}));
end Mixer;
