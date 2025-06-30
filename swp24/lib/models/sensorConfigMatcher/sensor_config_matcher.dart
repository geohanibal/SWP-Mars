
/// Author: Sergi Koniashvili
///
/// The `SensorConfigMatcher` class provides a mechanism for mapping MQTT topic names 
/// to their corresponding sensor configuration names. This is useful for identifying
/// the type of sensor or configuration associated with a given topic.
///
/// The class uses a static `Map` called `topicToSensorConfigName`, which contains topic 
/// names as keys and their respective sensor configuration names as values. The [getSensorConfigName]
/// function allows for easy lookup of sensor configuration names based on topic identifiers.
class SensorConfigMatcher {
  
  /// A static map that holds MQTT topic names as keys and their corresponding 
  /// sensor configuration names as values.
  static const Map<String, String> topicToSensorConfigName = {
  "board1_temp1_am": "Temperature",
  "board1_temp2_am": "Temperature",
  "board1_temp3_am": "Temperature",
  "board1_temp4_am": "Temperature",
  "board2_temp1_am": "Temperature",
  "board2_temp2_am": "Temperature",
  "board2_temp3_am": "Temperature",
  "board2_temp4_am": "Temperature",
  "board3_temp1_am": "Temperature",
  "board3_temp2_am": "Temperature",
  "board3_temp3_am": "Temperature",
  "board3_temp4_am": "Temperature",
  "board4_temp1_am": "Temperature",
  "board4_temp2_am": "Temperature",
  "board4_temp3_am": "Temperature",
  "board4_temp4_am": "Temperature",
  "board1_amb_press": "Air Pressure",
  "board2_amb_press": "Air Pressure",
  "board3_amb_press": "Air Pressure",
  "board4_amb_press": "Air Pressure",
  "board1_o2": "O2 Concentration",
  "board2_o2": "O2 Concentration",
  "board3_o2": "O2 Concentration",
  "board4_o2": "O2 Concentration",
  "board1_co2": "CO2 Concentration",
  "board2_co2": "CO2 Concentration",
  "board3_co2": "CO2 Concentration",
  "board4_co2": "CO2 Concentration",
  "board1_co": "CO Concentration",
  "board2_co": "CO Concentration",
  "board3_co": "CO Concentration",
  "board4_co": "CO Concentration",
  "board1_o3": "O3 Concentration",
  "board2_o3": "O3 Concentration",
  "board3_o3": "O3 Concentration",
  "board4_o3": "O3 Concentration",
  "board1_humid1_am": "Humidity",
  "board1_humid2_am": "Humidity",
  "board1_humid3_am": "Humidity",
  "board1_humid4_am": "Humidity",
  "board2_humid1_am": "Humidity",
  "board2_humid2_am": "Humidity",
  "board2_humid3_am": "Humidity",
  "board2_humid4_am": "Humidity",
  "board3_humid1_am": "Humidity",
  "board3_humid2_am": "Humidity",
  "board3_humid3_am": "Humidity",
  "board3_humid4_am": "Humidity",
  "board4_humid1_am": "Humidity",
  "board4_humid2_am": "Humidity",
  "board4_humid3_am": "Humidity",
  "board4_humid4_am": "Humidity",
  "pbr1_temp_l": "Temperature (Reactor, l)",
  "pbr1_temp_g_2": "Temperature (Output, g)",
  "pbr1_amb_press_2": "Air Pressure (Output, g)",
  "pbr1_do": "Dissolved O2 (PBR, l)",
  "pbr1_o2_2": "O2 Concentration (Output, g)",
  "pbr1_co2_2": "CO2 Concentration (Output, g)",
  "pbr1_rh_2": "Humidity (Output, g)",
  "pbr1_ph": "pH Value (PBR, l)",
  "pbr1_od": "Optical Density (PBR, l)",
};
  /// Retrieves the sensor configuration name associated with the given MQTT topic.
  ///
  /// - [topic]: The topic name as a [String] to look up in the map.
  /// - Returns: The corresponding sensor configuration name as a [String] if found, or `null` if no match exists.
  static String? getSensorConfigName(String topic) { // Funktion, die genutzt werden kann, um die richtige Datenbankbezeichnung zu erhalten.
    return topicToSensorConfigName[topic]; 
  }
}