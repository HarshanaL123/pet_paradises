import 'package:light/light.dart';

class LightSensorService {
  Light? _light;
  Function(double)? onLightChanged;

  void init() {
    _light = Light();
    startListening();
  }

  void startListening() {
    try {
      _light?.lightSensorStream.listen((luxValue) {
        if (onLightChanged != null) {
          onLightChanged!(luxValue.toDouble());
        }
      });
    } catch (e) {
      print('Error initializing light sensor: $e');
    }
  }

  void dispose() {
    _light = null;
  }
}