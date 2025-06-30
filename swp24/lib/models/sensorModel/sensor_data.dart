/// Author: Sergi Koniashvili
///
/// The `SensorData` class represents the data associated with a specific sensor.
/// This class holds the sensor's name, its current value, and the defined normal 
/// range (minimum and maximum values). It can be used to monitor and evaluate 
/// whether the sensor's current value is within the normal range.
class SensorData {
  /// The name of the sensor (e.g., "Temperature").
  final String name;
  /// The current measured value of the sensor.
  final double value;
  /// The minimum threshold of the normal range for the sensor.
  final double normalMin;
  /// The maximum threshold of the normal range for the sensor.
  final double normalMax;

  /// Constructor for initializing a `SensorData` object.
  ///
  /// - [name]: The name of the sensor.
  /// - [value]: The current value measured by the sensor.
  /// - [normalMin]: The minimum value of the normal range.
  /// - [normalMax]: The maximum value of the normal range.
  SensorData({
    required this.name,
    required this.value,
    required this.normalMin,
    required this.normalMax,
  });
}
