
/// Author: Giacomo Gargula
///
/// The `MeasurementMatcher` class acts as an assistant for mapping MQTT topic names 
/// to corresponding database identifiers. Upon initialization, the class defines a 
/// `topicToDatabaseMap` HashMap that contains MQTT topic names as keys and their 
/// corresponding database names as values.
///
/// This mapping simplifies the process of finding the correct database name for a given topic. 
/// The [getDatabaseName] function allows users to input an MQTT topic and retrieve 
/// the corresponding database name if a match is found.
class MeasurementMatcher {
  
  /// A constant map that holds MQTT topic names as keys and their corresponding 
  /// database identifiers as values.
  static const Map<String, String> topicToDatabaseMap = { // Die Hashmap, die initialisiert wird
    "board1/temp1_am": "board1_temp1_am",
    "board1/temp2_am": "board1_temp2_am",
    "board1/temp3_am": "board1_temp3_am",
    "board1/temp4_am": "board1_temp4_am",
    "board2/temp1_am": "board2_temp1_am",
    "board2/temp2_am": "board2_temp2_am",
    "board2/temp3_am": "board2_temp3_am",
    "board2/temp4_am": "board2_temp4_am",
    "board3/temp1_am": "board3_temp1_am",
    "board3/temp2_am": "board3_temp2_am",
    "board3/temp3_am": "board3_temp3_am",
    "board3/temp4_am": "board3_temp4_am",
    "board4/temp1_am": "board4_temp1_am",
    "board4/temp2_am": "board4_temp2_am",
    "board4/temp3_am": "board4_temp3_am",
    "board4/temp4_am": "board4_temp4_am",
    "board1/amb_press": "board1_amb_press",
    "board2/amb_press": "board2_amb_press",
    "board3/amb_press": "board3_amb_press",
    "board4/amb_press": "board4_amb_press",
    "board1/o2": "board1_o2",
    "board2/o2": "board2_o2",
    "board3/o2": "board3_o2",
    "board4/o2": "board4_o2",
    "board1/co2": "board1_co2",
    "board2/co2": "board2_co2",
    "board3/co2": "board3_co2",
    "board4/co2": "board4_co2",
    "board1/co": "board1_co",
    "board2/co": "board2_co",
    "board3/co": "board3_co",
    "board4/co": "board4_co",
    "board1/o3": "board1_o3",
    "board2/o3": "board2_o3",
    "board3/o3": "board3_o3",
    "board4/o3": "board4_o3",
    "board1/humid1_am": "board1_humid1_am",
    "board1/humid2_am": "board1_humid2_am",
    "board1/humid3_am": "board1_humid3_am",
    "board1/humid4_am": "board1_humid4_am",
    "board2/humid1_am": "board2_humid1_am",
    "board2/humid2_am": "board2_humid2_am",
    "board2/humid3_am": "board2_humid3_am",
    "board2/humid4_am": "board2_humid4_am",
    "board3/humid1_am": "board3_humid1_am",
    "board3/humid2_am": "board3_humid2_am",
    "board3/humid3_am": "board3_humid3_am",
    "board3/humid4_am": "board3_humid4_am",
    "board4/humid1_am": "board4_humid1_am",
    "board4/humid2_am": "board4_humid2_am",
    "board4/humid3_am": "board4_humid3_am",
    "board4/humid4_am": "board4_humid4_am",
    "pbr1/temp_1": "pbr1_temp_l",
    "pbr1/temp_g_2": "pbr1_temp_g_2",
    "pbr1/amb_press_2": "pbr1_amb_press_2",
    "pbr1/do": "pbr1_do",
    "pbr1/o2_2": "pbr1_o2_2",
    "pbr1/co2_2": "pbr1_co2_2",
    "pbr1/rh_2": "pbr1_rh_2",
    "pbr1/ph": "pbr1_ph",
    "pbr1/od": "pbr1_od",
  };
  /// Returns the database name that corresponds to the given MQTT topic.
  /// 
  /// - [topic]: The MQTT topic to search for in the map.
  /// - Returns: The database name as a [String] if a match is found, or `null` otherwise.
  static String? getDatabaseName(String topic) { 
    return topicToDatabaseMap[topic]; 
  }
}
