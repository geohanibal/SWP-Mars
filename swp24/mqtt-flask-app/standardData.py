class Type:
    def __init__(self, typeName, minCritL, minCritU, acceptMin, acceptMax, maxCritL, maxCritU):
        self.typeName = typeName
        self.minCriticalLower = minCritL
        self.minCriticalUpper = minCritU
        self.acceptMin = acceptMin
        self.acceptMax = acceptMax
        self.maxCriticalLower = maxCritL
        self.maxCriticalUpper = maxCritU

    def __repr__(self):
        return (f"Type(typeName={self.typeName}, "
                f"minCriticalLower={self.minCriticalLower}, "
                f"minCirticalUpper={self.minCriticalUpper}, "
                f"acceptMin={self.acceptMin}, "
                f"acceptMax={self.acceptMax}, "
                f"maxCriticalLower={self.maxCriticalLower}, "
                f"maxCirticalUpper={self.maxCriticalUpper}")

class Sensor:
    def __init__(self, type : Type, topic):
        self.type = type
        self.topic = topic

    def __repr__(self):
        return (f"Sensor(type={self.type}, "
                f"topic={self.topic})")

bAirTempType = Type("Air Temperature", 18, 18, 25, 32, 35, 36)
bAirPressureType = Type("Air Pressure", 900, 920, 950, 1040, 1080, 1100)
bO2Type = Type("O2 Concentration", 0, 18, 21, 23, 25, 35)
bCO2Type = Type("CO2 Concentration", 0, 0, 300, 2900, 3000, 4000)
bCOType = Type("CO Concentration", 0, 0, 0, 5, 25, 30)
bO3Type = Type("O3 Concentration", 0, 0, 0, 100, 150, 200)
bHumidityType = Type("Humidity", 0 , 0 , 40, 95, 100, 100)
pbrTempLType = Type("Temperature (PBR, l)", 18, 18, 25, 32, 35, 36)
pbrTempGType = Type("Temperature (PBR, g)", 18, 18, 25, 32, 35, 36)
pbrAirPressureType = Type("Air Pressure (PBR, g)", 900, 920, 950, 1040, 1080, 1100)
pbrDisO2Type = Type("Dissolved O2 (PBR, l)", 0, 3, 5, 15, 16, 20)
pbrO2Type = Type("O2 (PBR, g)", 0, 18, 21, 35, 35, 35)
pbrCO2Type = Type("CO2 (PBR, g)", 0, 0, 0, 400, 1000, 3000)
pbrHumidityType = Type("Humidity (PBR, g)", 0, 18, 21, 35, 35, 35)
pbrPHType = Type("pH Value (PBR, l)", 0, 5, 6, 11, 12, 14)
pbrODType = Type("Optical Density (PBR, l)", 0, 0, 0.1, 0.9, 1, 1)


sensors = [
    # Board Air Temperatures
    Sensor(bAirTempType, "board1/temp1_am"),
    Sensor(bAirTempType, "board1/temp2_am"),
    Sensor(bAirTempType, "board1/temp3_am"),
    Sensor(bAirTempType, "board1/temp4_am"),

    Sensor(bAirTempType, "board2/temp1_am"),
    Sensor(bAirTempType, "board2/temp2_am"),
    Sensor(bAirTempType, "board2/temp3_am"),
    Sensor(bAirTempType, "board2/temp4_am"),

    Sensor(bAirTempType, "board3/temp1_am"),
    Sensor(bAirTempType, "board3/temp2_am"),
    Sensor(bAirTempType, "board3/temp3_am"),
    Sensor(bAirTempType, "board3/temp4_am"),

    Sensor(bAirTempType, "board4/temp1_am"),
    Sensor(bAirTempType, "board4/temp2_am"),
    Sensor(bAirTempType, "board4/temp3_am"),
    Sensor(bAirTempType, "board4/temp4_am"),

    # Board Air Pressures
    Sensor(bAirPressureType, "board1/amb_press"),
    Sensor(bAirPressureType, "board2/amb_press"),
    Sensor(bAirPressureType, "board3/amb_press"),
    Sensor(bAirPressureType, "board4/amb_press"),

    # Board O2 Concentration
    Sensor(bO2Type, "board1/o2"),
    Sensor(bO2Type, "board2/o2"),
    Sensor(bO2Type, "board3/o2"),
    Sensor(bO2Type, "board4/o2"),

    # Board CO2 Concentration
    Sensor(bCO2Type, "board1/co2"),
    Sensor(bCO2Type, "board2/co2"),
    Sensor(bCO2Type, "board3/co2"),
    Sensor(bCO2Type, "board4/co2"),

    # Board CO Concentration
    Sensor(bCOType, "board1/co"),
    Sensor(bCOType, "board2/co"),
    Sensor(bCOType, "board3/co"),
    Sensor(bCOType, "board4/co"),

    # Board O3 Concentration
    Sensor(bO3Type, "board1/o3"),
    Sensor(bO3Type, "board2/o3"),
    Sensor(bO3Type, "board3/o3"),
    Sensor(bO3Type, "board4/o3"),

    # Board Humidities
    Sensor(bHumidityType, "board1/humid1_am"),
    Sensor(bHumidityType, "board1/humid2_am"),
    Sensor(bHumidityType, "board1/humid3_am"),
    Sensor(bHumidityType, "board1/humid4_am"),

    Sensor(bHumidityType, "board2/humid1_am"),
    Sensor(bHumidityType, "board2/humid2_am"),
    Sensor(bHumidityType, "board2/humid3_am"),
    Sensor(bHumidityType, "board2/humid4_am"),

    Sensor(bHumidityType, "board3/humid1_am"),
    Sensor(bHumidityType, "board3/humid2_am"),
    Sensor(bHumidityType, "board3/humid3_am"),
    Sensor(bHumidityType, "board3/humid4_am"),

    Sensor(bHumidityType, "board4/humid1_am"),
    Sensor(bHumidityType, "board4/humid2_am"),
    Sensor(bHumidityType, "board4/humid3_am"),
    Sensor(bHumidityType, "board4/humid4_am"),

    # Photobioreactor
    Sensor(pbrTempLType, "pbr1/temp_1"),
    Sensor(pbrTempGType, "pbr1/temp_g_2"),
    Sensor(pbrAirPressureType, "pbr1/amb_press_2"),
    Sensor(pbrDisO2Type, "pbr1/do"),
    Sensor(pbrO2Type, "pbr1/o2_2"),
    Sensor(pbrCO2Type, "pbr1/co2_2"),
    Sensor(pbrHumidityType, "pbr1/rh_2"),
    Sensor(pbrPHType, "pbr1/ph"),
    Sensor(pbrODType, "pbr1/od"),
]

chat = [
    {"type":"Messages from the GUI",
     "topic":"chatbot/user"},
    {"type":"Messages for the GUI",
     "topic":"chatbot/mission_control"}
]