within ThermodynamicDesign.Components;

model SteamGenerator
  replaceable package Medium = Modelica.Media.Interfaces.PartialPureSubstance;
  import Modelica.Units.SI;
    
  Medium.ThermodynamicState state_in = Medium.setState_phX(p_in, h_in) "State at inlet port";
  Medium.ThermodynamicState state_out = Medium.setState_phX(p_out, h_out) "State at outlet port";
  Medium.ThermodynamicState state_amb = Medium.setState_phX(Medium.p_default, Medium.h_default) "State at default ambient conditions";
  
  SI.QualityFactor X_in = Medium.vapourQuality(state_in) "Vapour mass fraction at inlet";
  SI.QualityFactor X_out = Medium.vapourQuality(state_out) "Vapour mass fraction at outlet";
  
  SI.SpecificEnthalpy h_in = inStream(port_a.h_outflow) "Specific enthalpy at SG inlet";
  SI.SpecificEnthalpy h_out = port_b.h_outflow "Specific enthalpy at SG outlet";
  
  SI.MassFlowRate m_in = port_a.m_flow "Mass flow into the SG at the inlet";
  SI.MassFlowRate m_out = port_b.m_flow "Mass flow rate into the SG at the outlet";
  
  SI.Power e_in = m_in*(h_in - Medium.temperature(state_amb)*Medium.specificEntropy(state_in)) "Exergy rate at the inlet";
  SI.Power e_out = m_out*(h_out - Medium.temperature(state_amb)*Medium.specificEntropy(state_out)) "Exergy rate at the inlet";
  SI.Power e_destr = e_in - e_out "Exergy rate of destruction";
  
  SI.AbsolutePressure p_in = port_a.p "SG inlet pressure";
  SI.AbsolutePressure p_out = port_b.p "SG outlet pressure";
  
  SI.HeatFlowRate Q "Heat flow rate into the SG";
  
  Modelica.Fluid.Interfaces.FluidPort_a port_a(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, -1}, extent = {{-20, -19}, {20, 19}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  
  // Mass balance (no mass storage)
  0 = m_in + m_out;
  
  // Isobaric conditions
  p_in = p_out;

  // Energy balance
  m_in*h_in + m_out*h_out + Q = 0;
  
  // Dummy assignment - reverse mass flow not supported
  port_a.h_outflow = port_b.h_outflow;

  annotation(
    uses(Modelica(version = "4.0.0")),
    Icon(graphics = {Text(origin = {0, 87}, extent = {{-64, -25}, {64, 25}}, textString = "%name"), Rectangle(fillColor = {222, 57, 42}, fillPattern = FillPattern.Solid,lineThickness = 1, extent = {{-80, 60}, {80, -60}})}));

end SteamGenerator;
