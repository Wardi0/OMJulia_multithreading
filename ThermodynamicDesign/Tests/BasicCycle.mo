within ThermodynamicDesign.Tests;

model BasicCycle

  import Modelica.Units.SI;
  replaceable package Medium = Modelica.Media.Water.StandardWater;

  ThermodynamicDesign.Components.Turbine turbine(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {40, -1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  ThermodynamicDesign.Components.SteamGenerator steamGenerator(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  ThermodynamicDesign.Components.DesignPoint SP1(replaceable package Medium = Medium, T_set = 273 + 500, p_set(displayUnit = "Pa") = 160e5)  annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.Condenser condenser(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  ThermodynamicDesign.Components.DesignPoint SP2(replaceable package Medium = Medium, T_set = 273 + 30, use_T = true)  annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.Pump pump(replaceable package Medium = Medium, m_set = 1, setFlow = true)  annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  SI.Efficiency eta_energ = (turbine.W + pump.W)/steamGenerator.Q;
  SI.Efficiency eta_exerg = eta_energ/(1-Medium.temperature(condenser.state_out)/Medium.temperature(steamGenerator.state_out));

equation
  connect(steamGenerator.port_b, SP1.port_a) annotation(
    Line(points = {{16, 40}, {26, 40}}, color = {0, 127, 255}));
  connect(SP1.port_b, turbine.port_a) annotation(
    Line(points = {{34, 40}, {40, 40}, {40, 16}}, color = {0, 127, 255}));
  connect(condenser.port_b, SP2.port_a) annotation(
    Line(points = {{-16, -40}, {-26, -40}}, color = {0, 127, 255}));
  connect(pump.port_b, steamGenerator.port_a) annotation(
    Line(points = {{-40, 16}, {-40, 40}, {-16, 40}}, color = {0, 127, 255}));
  connect(pump.port_a, SP2.port_b) annotation(
    Line(points = {{-40, -16}, {-40, -40}, {-34, -40}}, color = {0, 127, 255}));
  connect(turbine.port_b, condenser.port_a) annotation(
    Line(points = {{40, -16}, {40, -40}, {16, -40}}, color = {0, 127, 255}));
end BasicCycle;
