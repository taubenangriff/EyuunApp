import 'package:oxygen/oxygen.dart';

abstract class EyuunComponent<T> extends Component<T> {
  Map<String, dynamic> saveDynamicData();
  void loadDynamicData(Map<String, dynamic> dynamicData);

  void loadStaticData(Map<String, dynamic> staticData);
  String getName();
}