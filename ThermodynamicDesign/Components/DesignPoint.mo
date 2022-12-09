within ThermodynamicDesign.Components;

model DesignPoint

  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;
  
  parameter Boolean use_T = true "=true if the temperature should be used for the set point, otherwise the enthalpy is used";
  parameter SI.SpecificEnthalpy h_set "Set specific enthalpy";
  parameter SI.Temperature T_set = Medium.saturationTemperature(p_set)"Set temperature";
  parameter SI.AbsolutePressure p_set = Medium.saturationPressure(T_set)"Set pressure";
   
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
  
  if use_T then
    h = Medium.specificEnthalpy_pT(p_set,T_set);
  else
    h = h_set;
  end if;

annotation(
    Icon(graphics = {Rectangle(fillColor = {86, 238, 39}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-40, 40}, {40, -40}})}));
end DesignPoint;
