import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.g.dart';
part 'model.freezed.dart';

enum ControlType {
  constant,
  boolean,
  choice,
  number,
  range,
  date,
  dateRange,
}

@freezed
class Range with _$Range {
  // final num start;
  // final num end;
  // final num step;

  const factory Range({
    required double start,
    required double end,
    required int divs,
  }) = _Range;

  factory Range.fromJson(Map<String, Object?> json) => _$RangeFromJson(json);
}

@freezed
class DateRange with _$DateRange {
  const factory DateRange({
    required DateTime start,
    required DateTime end,
  }) = $DateRange;

  factory DateRange.empty() {
    return DateRange(start: DateTime.now(), end: DateTime.now());
  }

  factory DateRange.fromJson(Map<String, Object?> json) =>
      _$DateRangeFromJson(json);
}

@freezed
class Option with _$Option {
  const factory Option({required String name, required String value}) = $Option;

  factory Option.fromJson(Map<String, Object?> json) => _$OptionFromJson(json);
}

@freezed
class BoolOpts with _$BoolOpts {
  const factory BoolOpts({
    @Default("On") String trueLabel,
    @Default("Off") String falseLabel,
    @Default("") String noneLabel,
  }) = $BoolOpts;

  factory BoolOpts.fromJson(Map<String, Object?> json) =>
      _$BoolOptsFromJson(json);
}

@freezed
class ControlProps with _$ControlProps {
  const factory ControlProps({
    Range? range,
    DateRange? dateRange,
    @Default(<Option>[]) List<Option> options,
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
class RangeValuesX extends RangeValues {
  const RangeValuesX(super.start, super.end);

  factory RangeValuesX.fromJson(Map<String, Object?> json) =>
      _$RangeValuesXFromJson(json);

  Map<String, dynamic> toJson() => _$RangeValuesXToJson(this);
}

@JsonSerializable()
class DateTimeRangeX extends DateTimeRange {
  DateTimeRangeX(DateTime start, DateTime end) : super(start: start, end: end);

  factory DateTimeRangeX.empty() =>
      DateTimeRangeX(DateTime.now(), DateTime.now());

  factory DateTimeRangeX.fromJson(Map<String, Object?> json) =>
      _$DateTimeRangeXFromJson(json);

  Map<String, dynamic> toJson() => _$DateTimeRangeXToJson(this);
}

@JsonSerializable()
class ControlValues {
  Map<String, String>? strings;
  Map<String, bool>? bools;
  Map<String, double>? numbers;
  Map<String, RangeValuesX>? ranges;
  Map<String, DateTime>? dateTimes;
  Map<String, DateTimeRangeX>? dateTimeRanges;

  ControlValues({
    this.strings,
    this.bools,
    this.numbers,
    this.ranges,
    this.dateTimes,
    this.dateTimeRanges,
  });

  factory ControlValues.fromJson(Map<String, Object?> json) =>
      _$ControlValuesFromJson(json);

  Map<String, dynamic> toJson() => _$ControlValuesToJson(this);

  bool getBool(String key) {
    return bools?[key] ?? false;
  }

  String getString(String key) {
    return strings?[key] ?? '';
  }

  double getNumber(String key) {
    return numbers?[key] ?? 0.0;
  }

  RangeValuesX getRange(String key) {
    var val = ranges?[key];
    if (val != null) {
      return val;
    }
    return const RangeValuesX(0.0, 0.0);
  }

  DateTime getDateTime(String key) {
    return dateTimes?[key] ?? DateTime.now();
  }

  DateTimeRangeX getDateTimeRange(String key) {
    return dateTimeRanges?[key] ?? DateTimeRangeX.empty();
  }
}
