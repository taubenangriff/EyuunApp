import 'package:dart_mappable/dart_mappable.dart';

part 'CastScope.mapper.dart';

@MappableEnum(mode: ValuesMode.named)

enum CastScope {
  Self,
  Sight,
  SightRadius,
  Touch,
  Circle,
  Rectangle,
  Cone,
  Cuboid,
  Variant
}

extension CastScopeText on CastScope {
  String getTextKey() {
    return switch(this){

      // TODO: Handle this case.
      CastScope.Self => 'uitext_castscope_self',
      CastScope.Sight => 'uitext_castscope_sight',
      CastScope.SightRadius => 'uitext_castscope_sightRadius',
      CastScope.Touch => 'uitext_castscope_touch',
      CastScope.Circle => 'uitext_castscope_circle',
      CastScope.Rectangle => 'uitext_castscope_rectangle',
      CastScope.Cone => 'uitext_castscope_cone',
      CastScope.Cuboid => 'uitext_castscope_cuboid',
      CastScope.Variant => 'uitext_castscope_variant',
    };
  }
}
