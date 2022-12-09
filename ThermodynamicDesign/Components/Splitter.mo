within ThermodynamicDesign.Components;

model Splitter

  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;

  parameter Real split_fraction = 0.5 "Mass flow rate split fraction of outlet 1";
  
  Modelica.Fluid.Interfaces.FluidPort_a port_in(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out_1(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {60, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_out_2(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {60, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  port_in.p = port_out_1.p;
  port_in.p = port_out_2.p;
  
  inStream(port_in.h_outflow) = port_out_1.h_outflow;
  inStream(port_in.h_outflow) = port_out_2.h_outflow;
  port_in.h_outflow = 0;
  
  -port_out_1.m_flow = split_fraction * port_in.m_flow;
  -port_out_2.m_flow = (1-split_fraction) * port_in.m_flow;
  
  assert(split_fraction >= 0 and split_fraction <= 1, "split_fraction must be in range (0,1)");

annotation(
    Icon(graphics = {Polygon(origin = {10, 0}, fillColor = {244, 244, 103}, fillPattern = FillPattern.Solid, lineThickness = 2, points = {{-50, 20}, {-50, -20}, {-20, -20}, {50, -60}, {50, 60}, {-20, 20}, {-50, 20}, {-50, 20}}), Line(origin = {30, 0}, points = {{-30, 0}, {30, 0}, {30, 0}}, thickness = 1.5), Polygon(origin = {-10, 160}, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(origin = {-10, 160}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(origin = {-11.318, -9.83784}, rotation = 180, points = {{25, -85}, {-60, -85}}, color = {0, 128, 255})}));
end Splitter;
