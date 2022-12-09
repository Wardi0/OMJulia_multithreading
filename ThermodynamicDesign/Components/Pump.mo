within ThermodynamicDesign.Components;

model Pump

  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;

  parameter SI.Efficiency eta_is = 0.9 "Isentropic efficiency";
  parameter SI.Efficiency eta_mech = 0.9 "Mechanical efficiency";
  
  parameter Boolean setFlow = false "=true to control the mass flow rate";
  parameter SI.MassFlowRate m_set "Mass flow rate through the pump";
    
  Medium.ThermodynamicState state_in "State at inlet port";
  Medium.ThermodynamicState state_out "State at outlet port";
  Medium.ThermodynamicState state_amb = Medium.setState_phX(Medium.p_default, Medium.h_default) "State at default ambient conditions";
  
  SI.QualityFactor X_in = Medium.vapourQuality(state_in) "Vapour mass fraction at inlet";
  SI.QualityFactor X_out = Medium.vapourQuality(state_out) "Vapour mass fraction at outlet";
  
  SI.SpecificEnthalpy h_in = inStream(port_a.h_outflow) "Specific enthalpy at pump inlet";
  SI.SpecificEnthalpy h_out = port_b.h_outflow "Specific enthalpy at pump outlet";
  SI.SpecificEnthalpy delta_h "Actual change in specific enthalpy";
  SI.SpecificEnthalpy delta_h_is "Isentropic change in specific enthalpy";
  
  SI.MassFlowRate m_in = port_a.m_flow "Mass flow into the pump at the inlet";
  SI.MassFlowRate m_out = port_b.m_flow "Mass flow rate into the pump at the outlet";
  
  SI.Power e_in = m_in*(h_in - Medium.temperature(state_amb)*Medium.specificEntropy(state_in)) "Exergy rate at the inlet";
  SI.Power e_out = m_out*(h_out - Medium.temperature(state_amb)*Medium.specificEntropy(state_out)) "Exergy rate at the inlet";
  SI.Power e_destr = e_in - e_out - W "Specific exergy rate of destruction";
  
  SI.AbsolutePressure p_in = port_a.p "Pump inlet pressure";
  SI.AbsolutePressure p_out = port_b.p "Pump outlet pressure";
  
  SI.Power W "Mechanical work of the pump";
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -1}, extent = {{-20, -19}, {20, 19}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


equation
  
  // Medium state for ports
  state_in = Medium.setState_phX(p_in, h_in);
  state_out = Medium.setState_phX(p_out, h_out);
  
  // Mass balance (no mass storage)
  0 = m_in + m_out;
  if setFlow == true then
    m_in = m_set;
  end if;
  
  // Enthalpy balance defined by the isentropic efficiency
  h_in - h_out = delta_h;
  h_in - Medium.specificEnthalpy_ps(port_b.p, Medium.specificEntropy(state_in)) = delta_h_is;
  delta_h = eta_is * delta_h_is;
  
  // Dummy assignment - reverse mass flow not supported
  port_a.h_outflow = port_b.h_outflow;
  
  // Work calculation
  W = m_in*(h_in-h_out)*eta_mech;

  annotation(
    uses(Modelica(version = "4.0.0")),
    Icon(graphics = {Text(origin = {0, 115}, extent = {{-64, -25}, {64, 25}}, textString = "%name"), Ellipse(fillColor = {170, 170, 170}, fillPattern = FillPattern.Solid,lineThickness = 1, extent = {{-80, -80}, {80, 80}}), Polygon(origin = {13, 0}, fillColor = {203, 203, 203}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-67, 58}, {-67, -58}, {67, 0}, {-67, 58}})}));

end Pump;
