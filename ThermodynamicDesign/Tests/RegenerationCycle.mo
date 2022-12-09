within ThermodynamicDesign.Tests;

model RegenerationCycle

  import Modelica.Units.SI;
  replaceable package Medium = Modelica.Media.Water.StandardWater;

  ThermodynamicDesign.Components.Turbine HPT(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {64, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  ThermodynamicDesign.Components.SteamGenerator steamGenerator(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  ThermodynamicDesign.Components.DesignPoint main_steam_state(replaceable package Medium = Medium, T_set = 273 + 400, p_set(displayUnit = "Pa") = 1.618e7)  annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.Condenser condenser(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {102, -40}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  ThermodynamicDesign.Components.DesignPoint SP2(replaceable package Medium = Medium, T_set = 273 + 30, use_T = true)  annotation(
    Placement(visible = true, transformation(origin = {66, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.Pump pump(replaceable package Medium = Medium, m_set = 1, setFlow = true)  annotation(
    Placement(visible = true, transformation(origin = {-40, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  SI.Efficiency eta_energ = (HPT.W + LPT.W + pump.W + pump1.W)/(steamGenerator.Q + reheater.Q);
  SI.Efficiency eta_exerg = eta_energ/(1-Medium.temperature(condenser.state_out)/Medium.temperature(steamGenerator.state_out));
  ThermodynamicDesign.Components.Turbine LPT(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {196, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Components.Splitter splitter(replaceable package Medium = Medium, split_fraction = 1 - 0.275) annotation(
    Placement(visible = true, transformation(origin = {104, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.Pump pump1(replaceable package Medium = Medium, m_set = 0.5, setFlow = false) annotation(
    Placement(visible = true, transformation(origin = {34, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.Mixer open_FWH(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-11, -37}, extent = {{11, -11}, {-11, 11}}, rotation = 0)));
  ThermodynamicDesign.Components.LoopBreaker loopBreaker(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-40, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  ThermodynamicDesign.Components.SteamGenerator reheater(replaceable package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {140, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermodynamicDesign.Components.DesignPoint reheat_steam_state(replaceable package Medium = Medium, T_set = 273 + 400, p_set(displayUnit = "Pa") = 1.139e6) annotation(
    Placement(visible = true, transformation(origin = {164, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(steamGenerator.port_b, main_steam_state.port_a) annotation(
    Line(points = {{16, 40}, {26, 40}}, color = {0, 127, 255}));
  connect(condenser.port_b, SP2.port_a) annotation(
    Line(points = {{86, -40}, {70, -40}}, color = {0, 127, 255}));
  connect(pump.port_b, steamGenerator.port_a) annotation(
    Line(points = {{-40, 24}, {-40, 40}, {-16, 40}}, color = {0, 127, 255}));
  connect(main_steam_state.port_b, HPT.port_a) annotation(
    Line(points = {{34, 40}, {48, 40}}, color = {0, 127, 255}));
  connect(LPT.port_b, condenser.port_a) annotation(
    Line(points = {{212, 44}, {220, 44}, {220, -40}, {118, -40}}, color = {0, 127, 255}));
  connect(pump1.port_a, SP2.port_b) annotation(
    Line(points = {{42, -40}, {62, -40}}, color = {0, 127, 255}));
  connect(open_FWH.port_in_2, pump1.port_b) annotation(
    Line(points = {{-7, -40}, {26, -40}}, color = {0, 127, 255}));
  connect(splitter.port_out_2, open_FWH.port_in_1) annotation(
    Line(points = {{110, 38}, {120, 38}, {120, -10}, {4, -10}, {4, -34}, {-6, -34}}, color = {0, 127, 255}));
  connect(open_FWH.port_out, loopBreaker.port_a) annotation(
    Line(points = {{-18, -36}, {-40, -36}, {-40, -20}}, color = {0, 127, 255}));
  connect(pump.port_a, loopBreaker.port_b) annotation(
    Line(points = {{-40, 8}, {-40, -12}}, color = {0, 127, 255}));
  connect(splitter.port_out_1, reheater.port_a) annotation(
    Line(points = {{110, 44}, {132, 44}}, color = {0, 127, 255}));
  connect(reheater.port_b, reheat_steam_state.port_a) annotation(
    Line(points = {{148, 44}, {160, 44}}, color = {0, 127, 255}));
  connect(reheat_steam_state.port_b, LPT.port_a) annotation(
    Line(points = {{168, 44}, {180, 44}}, color = {0, 127, 255}));
  connect(HPT.port_b, splitter.port_in) annotation(
    Line(points = {{80, 40}, {100, 40}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-80, 80}, {180, -60}})));
end RegenerationCycle;
