import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.g.dart';
part 'model.freezed.dart';

enum ControlType {
  constant,
  boolean,
  choice,
  range,
  date,
  dateRange,
}

@freezed
class Range with _$Range {
  // final num start;
  // final num end;
  // final num step;

  const factory Range(
      {required num start, required num end, required num step}) = _Range;

  factory Range.fromJson(Map<String, Object?> json) => _$RangeFromJson(json);
}

@freezed
class DateRange with _$DateRange {
  const factory DateRange({required DateTime start, required DateTime end}) =
      $DateRange;

  factory DateRange.fromJson(Map<String, Object?> json) =>
      _$DateRangeFromJson(json);
}

@freezed
class Options with _$Options {
  const factory Options({required String name, required String value}) =
      $Option;

  factory Options.fromJson(Map<String, Object?> json) =>
      _$OptionsFromJson(json);
}

@freezed
class BoolOpts with _$BoolOpts {
  const factory BoolOpts({
    @Default("On") String trueLabel,
    @Default("Off") String falseLabel,
    @Default(false) bool hasNone,
    @Default("") String noneLabel,
  }) = $BoolOpts;

  factory BoolOpts.fromJson(Map<String, Object?> json) =>
      _$BoolOptsFromJson(json);
}

@freezed
class ControlProps with _$ControlProps {
  const factory ControlProps({
    Range? range,
    DateRange? dates,
    Options? options,
    BoolOpts? boolOpts,
    String? constVal,
  }) = $ControlProps;

  factory ControlProps.fromJson(Map<String, Object?> json) =>
      _$ControlPropsFromJson(json);
}

@freezed
class ControlItem with _$ControlItem {
  const factory ControlItem({
    required String id,
    required String name,
    required String desc,
    required ControlType type,
    required ControlProps props,
  }) = $ControlItem;

  factory ControlItem.fromJson(Map<String, Object?> json) =>
      _$ControlItemFromJson(json);
}

@freezed
class ControlGroup with _$ControlGroup {
  const factory ControlGroup({
    required String name,
    required List<ControlItem> items,
  }) = $ControlGroup;

  factory ControlGroup.fromJson(Map<String, Object?> json) =>
      _$ControlGroupFromJson(json);
}

@JsonSerializable()
class ControlValues {
  final Map<String, dynamic> values;

  ControlValues(this.values);

  factory ControlValues.fromJson(Map<String, Object?> json) =>
      _$ControlValuesFromJson(json);

  Map<String, dynamic> toJson() => _$ControlValuesToJson(this);

  bool getBool(String key) {
    return (values[key] ?? false) as bool;
  }

  String getString(String key) {
    return (values[key] ?? '') as String;
  }
}
