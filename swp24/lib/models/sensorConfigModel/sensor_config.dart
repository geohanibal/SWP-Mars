/// Author: Sergi Koniashvili
///
/// The `SensorConfig` class represents the configuration of a specific sensor.
/// It defines thresholds for normal, warning (yellow), and extreme ranges
/// for the sensor's measured values. The class also provides methods to serialize 
/// and deserialize sensor configurations to and from JSON objects.
class SensorConfig {
  /// The name of the sensor configuration (e.g., "Temperature").
  final String name;
  /// The minimum value of the normal range for the sensor.
  double normalMin;
  /// The maximum value of the normal range for the sensor.
  double normalMax;
  /// The lower bound of the warning (yellow) range.
  double yellowLower;
  /// The upper bound of the warning (yellow) range.
  double yellowUpper;
  /// The minimum value of the extreme range for the sensor.
  double extremMin;
  /// The maximum value of the extreme range for the sensor.
  double extremMax;

  /// Constructor for initializing a `SensorConfig` object.
  ///
  /// All fields are required to ensure a fully defined configuration.
  SensorConfig({
    required this.name,
    required this.normalMin,
    required this.normalMax,
    required this.yellowLower,
    required this.yellowUpper,
    required this.extremMax,
    required this.extremMin,
  });

  /// Converts the sensor configuration to a JSON-compatible map.
  ///
  /// Returns a `Map<String, dynamic>` representation of the configuration.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'normalMin': normalMin,
      'normalMax': normalMax,
      'yellowLower': yellowLower,
      'yellowUpper': yellowUpper,
      'extremMax': extremMax,
      'extremMin': extremMin,
    };
  }

  /// Creates a `SensorConfig` object from a JSON-compatible map.
  ///
  /// - [json]: A `Map<String, dynamic>` containing the configuration data.
  /// - Returns: A `SensorConfig` object populated with the data from the map.
  factory SensorConfig.fromJson(Map<String, dynamic> json) {
    return SensorConfig(
      name: json['name'],
      normalMin: json['normalMin'],
      normalMax: json['normalMax'],
      yellowLower: json['yellowLower'],
      yellowUpper: json['yellowUpper'],
      extremMax: json['extremMax'],
      extremMin: json['extremMin'],
    );
  }
}
