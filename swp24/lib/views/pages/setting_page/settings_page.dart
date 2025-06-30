import 'package:flutter/material.dart';
import '../../../models/sensorConfigModel/sensor_config.dart';
import '../../../services/sensor_config_manager/sensor_config_manager.dart';
/// SettingsPage
/// Author: Sergi Koniashvili
/// This page allows users to view, edit, and save sensor configurations.
/// Users can update thresholds for sensors such as ExtremMin, YellowLower, NormalMin, etc.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SensorConfigManager _repository = SensorConfigManager(); // Manager to handle sensor configs
  List<SensorConfig> _configs = []; // List to store sensor configurations
  bool _isLoading = true; // Loading state indicator

  @override
  void initState() {
    super.initState();
    _loadConfigs(); // Load configurations when the page initializes
  }

   /// Loads sensor configurations from the repository
  Future<void> _loadConfigs() async {
    final configs = await _repository.loadConfigs();
    setState(() {
      _configs = configs;
      _isLoading = false;
    });
  }

  /// Saves the updated sensor configurations back to the repository. 
  /// ATTENTION: After each save, the application has to be restarted for the settings to apply.
  Future<void> _saveConfigs() async {
    await _repository.saveConfigs(_configs);
  }

  /// Updates the thresholds of a given sensor configuration and saves the changes.
  ///
  /// This function modifies the threshold values of a [SensorConfig] object with new values
  /// provided as parameters. After updating the configuration, it saves the changes
  /// to persistent storage by calling `_saveConfigs()`.
  ///
  /// **Parameters:**
  /// - [config]: The [SensorConfig] object to be updated.
  /// - [newExtremMin]: The new extreme minimum value for the sensor.
  /// - [newYellowLower]: The new lower boundary for the warning range.
  /// - [newNormalMin]: The new minimum value for the normal range.
  /// - [newNormalMax]: The new maximum value for the normal range.
  /// - [newYellowUpper]: The new upper boundary for the warning range.
  /// - [newExtremMax]: The new extreme maximum value for the sensor.
  ///
  /// **Process:**
  /// 1. Calls `setState()` to ensure the updated values are reflected in the UI.
  /// 2. Updates the threshold fields (`extremMin`, `yellowLower`, `normalMin`, `normalMax`, `yellowUpper`, `extremMax`) of the provided [SensorConfig] object with the new values.
  /// 3. Calls `_saveConfigs()` to persist the updated configuration to storage.
  void _updateConfig(SensorConfig config, double newExtremMin, double newYellowLower, double newNormalMin, double newNormalMax, double newYellowUpper, double newExtremMax) {
    setState(() {
      config.extremMin = newExtremMin;
      config.yellowLower = newYellowLower;
      config.normalMin = newNormalMin;
      config.normalMax = newNormalMax;
      config.yellowUpper = newYellowUpper;
      config.extremMax = newExtremMax;
    });
    _saveConfigs();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Settings'),
      ),
      body: ListView.builder(
        itemCount: _configs.length,
        itemBuilder: (context, index) {
          final config = _configs[index];
          return ListTile(
            title: Text(config.name),
            subtitle: Text(
                'ExtremMin: ${config.extremMin.toStringAsFixed(2)}, YellowLower: ${config.yellowLower.toStringAsFixed(2)}, NormalMin: ${config.normalMin.toStringAsFixed(2)}, NormalMax: ${config.normalMax.toStringAsFixed(2)}, YellowUpper: ${config.yellowUpper.toStringAsFixed(2)}, ExtremMax: ${config.extremMax.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await showDialog<Map<String, double>>(
                  context: context,
                  builder: (context) {
                    double newExtremMin = config.extremMin;
                    double newYellowLower = config.yellowLower;
                    double newNormalMin = config.normalMin;
                    double newNormalMax = config.normalMax;
                    double newYellowUpper = config.yellowUpper;
                    double newExtremMax = config.extremMax;

                    return AlertDialog(
                      title: Text('Edit ${config.name} Range'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Extrem Min Value'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              newExtremMin = double.tryParse(value) ?? newExtremMin;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Yellow Lower Value'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              newYellowLower = double.tryParse(value) ?? newYellowLower;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Normal Min Value'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              newNormalMin = double.tryParse(value) ?? newNormalMin;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Normal Max Value'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              newNormalMax = double.tryParse(value) ?? newNormalMax;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Yellow Upper Value'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              newYellowUpper = double.tryParse(value) ?? newYellowUpper;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Extrem Max Value'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              newExtremMax = double.tryParse(value) ?? newExtremMax;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop({
                              'newExtremMin': newExtremMin,
                              'newYellowLower': newYellowLower,
                              'newNormalMin': newNormalMin,
                              'newNormalMax': newNormalMax,
                              'newYellowUpper': newYellowUpper,
                              'newExtremMax': newExtremMax,
                            });
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );

                if (result != null) {
                  _updateConfig(
                    config,
                    result['newExtremMin']!,
                    result['newYellowLower']!,
                    result['newNormalMin']!,
                    result['newNormalMax']!,
                    result['newYellowUpper']!,
                    result['newExtremMax']!,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}