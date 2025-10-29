import 'EyuunComponent.dart';

/// Clone of ValueComponent, but extending EyuunComponent for polymorphies sake.
abstract class EyuunValueComponent<T> extends EyuunComponent<T> {
  T? value;

  @override
  void init([T? data]) => value = data;

  @override
  void reset() => value = null;
}