
/// Author: Sergi Koniashvili
///
/// The `NavigationMatcher` class provides a mechanism for mapping topic names 
/// to their corresponding routes in the application. This allows for easy lookup 
/// and retrieval of route paths based on specific topic identifiers.
///
/// The class uses a static `Map` called `topicToRoute`, which contains topic names 
/// as keys and their respective routes as values. The [getRoute] function can be 
/// used to fetch the appropriate route for a given topic.
class NavigationMatcher {
  
  /// A static map that holds topic identifiers as keys and their corresponding 
  /// route paths as values.
  static const Map<String, String> topicToRoute = {
  "board1_temp1_am": "/sensorboard/sensor_board_1",
  "board1_temp2_am": "/sensorboard/sensor_board_1",
  "board1_temp3_am": "/sensorboard/sensor_board_1",
  "board1_temp4_am": "/sensorboard/sensor_board_1",
  "board2_temp1_am": "/sensorboard/sensor_board_2",
  "board2_temp2_am": "/sensorboard/sensor_board_2",
  "board2_temp3_am": "/sensorboard/sensor_board_2",
  "board2_temp4_am": "/sensorboard/sensor_board_2",
  "board3_temp1_am": "/sensorboard/sensor_board_3",
  "board3_temp2_am": "/sensorboard/sensor_board_3",
  "board3_temp3_am": "/sensorboard/sensor_board_3",
  "board3_temp4_am": "/sensorboard/sensor_board_3",
  "board4_temp1_am": "/sensorboard/sensor_board_4",
  "board4_temp2_am": "/sensorboard/sensor_board_4",
  "board4_temp3_am": "/sensorboard/sensor_board_4",
  "board4_temp4_am": "/sensorboard/sensor_board_4",
  "board1_amb_press": "/sensorboard/sensor_board_1",
  "board2_amb_press": "/sensorboard/sensor_board_2",
  "board3_amb_press": "/sensorboard/sensor_board_3",
  "board4_amb_press": "/sensorboard/sensor_board_4",
  "board1_o2": "/",
  "board2_o2": "/",
  "board3_o2": "/",
  "board4_o2": "/",
  "board1_co2": "/",
  "board2_co2": "/",
  "board3_co2": "/",
  "board4_co2": "/",
  "board1_co": "/",
  "board2_co": "/",
  "board3_co": "/",
  "board4_co": "/",
  "board1_o3": "/",
  "board2_o3": "/",
  "board3_o3": "/",
  "board4_o3": "/",
  "board1_humid1_am": "/",
  "board1_humid2_am": "/",
  "board1_humid3_am": "/",
  "board1_humid4_am": "/",
  "board2_humid1_am": "/",
  "board2_humid2_am": "/",
  "board2_humid3_am": "/",
  "board2_humid4_am": "/",
  "board3_humid1_am": "/",
  "board3_humid2_am": "/",
  "board3_humid3_am": "/",
  "board3_humid4_am": "/",
  "board4_humid1_am": "/",
  "board4_humid2_am": "/",
  "board4_humid3_am": "/",
  "board4_humid4_am": "/",
  "pbr1_temp_l": "/photobioreactor/nutrient_medium",
  "pbr1_temp_g_2": "/photobioreactor/gas_outlet",
  "pbr1_amb_press_2": "/photobioreactor/gas_outlet",
  "pbr1_do": "/photobioreactor/nutrient_medium",
  "pbr1_o2_2": "/photobioreactor/gas_outlet",
  "pbr1_co2_2": "/photobioreactor/gas_outlet",
  "pbr1_rh_2": "/photobioreactor/gas_outlet",
  "pbr1_ph": "/photobioreactor/nutrient_medium",
  "pbr1_od": "/photobioreactor/nutrient_medium",
};
  /// Retrieves the route path associated with the given topic name.
  ///
  /// - [topic]: The topic name as a [String] to look up in the map.
  /// - Returns: The corresponding route path as a [String] if found, or `null` if no match exists.
  static String? getRoute(String topic) { // Funktion, die genutzt werden kann, um die richtige Routenbezeichnung zu erhalten.
    return topicToRoute[topic]; 
  }
}