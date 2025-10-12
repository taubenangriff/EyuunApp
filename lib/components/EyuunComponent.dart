import 'package:oxygen/oxygen.dart';

abstract class EyuunComponent<T> extends Component<T>
{
  //Writes the values necessary for persistance to a map
  Map<String, dynamic> persist();

  //Applies persisted values from a map to this entity
  void applyValues(Map<String, dynamic> valueMap);

  String getName();
}