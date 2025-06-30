
/// Author: Sergi Koniashvili
///
/// The `StatusMatcher` class provides a mechanism for mapping MQTT topic names 
/// to their corresponding sensor or system type. This allows easy identification
/// of the type (e.g., "Sensor" or "Photobioreactor") associated with a specific topic.
///
/// The class uses a static `Map` called `topicToSensortype`, which contains topic names 
/// as keys and their corresponding type as values. The [getSensorStatusType] function 
/// can be used to retrieve the type for a given topic.
class StatusMatcher {
  
  /// A static map that holds MQTT topic names as keys and their corresponding 
  /// sensor or system types as values.
  static const Map<String, String> topicToSensortype = {
  "board1_temp1_am": "Sensor",
  "board1_temp2_am": "Sensor",
  "board1_temp3_am": "Sensor",
  "board1_temp4_am": "Sensor",
  "board2_temp1_am": "Sensor",
  "board2_temp2_am": "Sensor",
  "board2_temp3_am": "Sensor",
  "board2_temp4_am": "Sensor",
  "board3_temp1_am": "Sensor",
  "board3_temp2_am": "Sensor",
  "board3_temp3_am": "Sensor",
  "board3_temp4_am": "Sensor",
  "board4_temp1_am": "Sensor",
  "board4_temp2_am": "Sensor",
  "board4_temp3_am": "Sensor",
  "board4_temp4_am": "Sensor",
  "board1_amb_press": "Sensor",
  "board2_amb_press": "Sensor",
  "board3_amb_press": "Sensor",
  "board4_amb_press": "Sensor",
  "board1_o2": "Sensor",
  "board2_o2": "Sensor",
  "board3_o2": "Sensor",
  "board4_o2": "Sensor",
  "board1_co2": "Sensor",
  "board2_co2": "Sensor",
  "board3_co2": "Sensor",
  "board4_co2": "Sensor",
  "board1_co": "Sensor",
  "board2_co": "Sensor",
  "board3_co": "Sensor",
  "board4_co": "Sensor",
  "board1_o3": "Sensor",
  "board2_o3": "Sensor",
  "board3_o3": "Sensor",
  "board4_o3": "Sensor",
  "board1_humid1_am": "Sensor",
  "board1_humid2_am": "Sensor",
  "board1_humid3_am": "Sensor",
  "board1_humid4_am": "Sensor",
  "board2_humid1_am": "Sensor",
  "board2_humid2_am": "Sensor",
  "board2_humid3_am": "Sensor",
  "board2_humid4_am": "Sensor",
  "board3_humid1_am": "Sensor",
  "board3_humid2_am": "Sensor",
  "board3_humid3_am": "Sensor",
  "board3_humid4_am": "Sensor",
  "board4_humid1_am": "Sensor",
  "board4_humid2_am": "Sensor",
  "board4_humid3_am": "Sensor",
  "board4_humid4_am": "Sensor",
  "pbr1_temp_l": "Photobioreactor",
  "pbr1_temp_g_2": "Photobioreactor",
  "pbr1_amb_press_2": "Photobioreactor",
  "pbr1_do": "Photobioreactor",
  "pbr1_o2_2": "Photobioreactor",
  "pbr1_co2_2": "Photobioreactor",
  "pbr1_rh_2": "Photobioreactor",
  "pbr1_ph": "Photobioreactor",
  "pbr1_od": "Photobioreactor",
};
  /// Retrieves the type (e.g., "Sensor", "Photobioreactor") associated with the given MQTT topic.
  ///
  /// - [topic]: The topic name as a [String] to look up in the map.
  /// - Returns: The corresponding type as a [String] if found, or `null` if no match exists.
  static String? getSensorStatusType(String topic) { // Funktion, die genutzt werden kann, um die richtige Datenbankbezeichnung zu erhalten.
    return topicToSensortype[topic]; 
  }
}