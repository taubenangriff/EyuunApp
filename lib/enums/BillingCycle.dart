import 'package:dart_mappable/dart_mappable.dart';

part 'BillingCycle.mapper.dart';

@MappableEnum(mode: ValuesMode.named)

enum BillingCycle {
  Once,
  PerRound,
  PerHour
}
