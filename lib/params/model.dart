import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.g.dart';
part 'model.freezed.dart';

enum ControlType {
  constant,
  boolean,
  tristate,
  choice,
  number,
  range,
  date,
  dateRange,
}

enum Tristate {
  on,
  off,
  none,
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
  }) = $BoolOpts;

  factory BoolOpts.fromJson(Map<String, Object?> json) =>
      _$BoolOptsFromJson(json);
}

@freezed
class TristateOpts with _$TristateOpts {
  const factory TristateOpts({
    @Default("On") String trueLabel,
    @Default("Off") String falseLabel,
    @Default("None") String noneLabel,
  }) = $TristateOpts;

  factory TristateOpts.fromJson(Map<String, Object?> json) =>
      _$TristateOptsFromJson(json);
}

@freezed
class ControlProps with _$ControlProps {
  const factory ControlProps({
    BoolOpts? boolOpts,
    TristateOpts? tristateOpts,
    @Default(<Option>[]) List<Option> options,
    Range? range,
    DateRange? dateRange,
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
    required String id,
    required String name,
    @Default("") String desc,
    required List<ControlItem> items,
  }) = $ControlGroup;

  factory ControlGroup.fromJson(Map<String, Object?> json) =>
      _$ControlGroupFromJson(json);
}

@JsonSerializable()
class RangeValuesX extends RangeValues {
  const RangeValuesX(super.start, super.end);

  factory RangeValuesX.fromRangeValues(RangeValues orig) =>
      RangeValuesX(orig.start, orig.end);

  factory RangeValuesX.fromJson(Map<String, Object?> json) =>
      _$RangeValuesXFromJson(json);

  Map<String, dynamic> toJson() => _$RangeValuesXToJson(this);
}

@JsonSerializable()
class DateTimeRangeX extends DateTimeRange {
  DateTimeRangeX(DateTime start, DateTime end) : super(start: start, end: end);

  factory DateTimeRangeX.fromDateTimeRange(DateTimeRange orig) =>
      DateTimeRangeX(orig.start, orig.end);

  factory DateTimeRangeX.fromDateRange(DateRange orig) =>
      DateTimeRangeX(orig.start, orig.end);

  factory DateTimeRangeX.empty() =>
      DateTimeRangeX(DateTime.now(), DateTime.now());

  factory DateTimeRangeX.fromJson(Map<String, Object?> json) =>
      _$DateTimeRangeXFromJson(json);

  Map<String, dynamic> toJson() => _$DateTimeRangeXToJson(this);
}

@JsonSerializable()
class ControlValues {
  Map<String, bool>? bools;
  Map<String, Tristate>? tristates;
  Map<String, String>? options;
  Map<String, double>? numbers;
  Map<String, RangeValuesX>? ranges;
  Map<String, DateTime>? dateTimes;
  Map<String, DateTimeRangeX>? dateTimeRanges;

  ControlValues({
    this.bools,
    this.tristates,
    this.options,
    this.numbers,
    this.ranges,
    this.dateTimes,
    this.dateTimeRanges,
  });

  factory ControlValues.fromJson(Map<String, Object?> json) =>
      _$ControlValuesFromJson(json);

  Map<String, dynamic> toJson() => _$ControlValuesToJson(this);

  bool getBool(ControlItem item) {
    if (bools == null) {
      return false;
    }
    return bools![item.id] ?? false;
  }

  Tristate getTristate(ControlItem item) {
    if (item.props.tristateOpts == null || tristates == null) {
      return Tristate.off;
    }

    return tristates![item.id] ?? Tristate.off;
  }

  String getString(ControlItem item) {
    final val = options?[item.id] ?? '';
    if (val.isNotEmpty) {
      return val;
    }

    if (item.props.options.isEmpty) {
      return 'N/A';
    }

    return item.props.options[0].value;
  }

  Option? getOption(ControlItem item) {
    final val = options?[item.id] ?? '';
    for (var opt in item.props.options) {
      if (val == opt.value) {
        return opt;
      }
    }

    if (item.props.options.isNotEmpty) {
      return item.props.options[0];
    }

    return null;
  }

  double getNumber(ControlItem item) {
    return numbers?[item.id] ?? item.props.range?.start ?? 0;
  }

  RangeValuesX getRange(ControlItem item) {
    var val = ranges?[item.id];
    if (val != null) {
      return val;
    }
    return RangeValuesX(
        item.props.range?.start ?? 0, item.props.range?.end ?? 0);
  }

  DateTime getDateTime(ControlItem item) {
    return dateTimes?[item.id] ?? item.props.dateRange?.start ?? DateTime.now();
  }

  DateTimeRangeX getDateTimeRange(ControlItem item) {
    var drx = dateTimeRanges?[item.id];
    if (drx != null) {
      return drx;
    }

    if (item.props.dateRange != null) {
      return DateTimeRangeX(
          item.props.dateRange!.start, item.props.dateRange!.end);
    }

    return DateTimeRangeX.empty();
  }

  void setValue(ControlItem item, dynamic value) {
    // Map<String, String>? strings;
    // Map<String, double>? numbers;
    // Map<String, RangeValuesX>? ranges;
    // Map<String, DateTime>? dateTimes;
    // Map<String, DateTimeRangeX>? dateTimeRanges;
    if (value == null) {
      return;
    }

    switch (item.type) {
      case ControlType.constant:
        break;
      case ControlType.boolean:
        (bools ??= <String, bool>{})[item.id] = value as bool;
      case ControlType.tristate:
        (tristates ??= <String, Tristate>{})[item.id] = value as Tristate;
      case ControlType.choice:
        (options ??= <String, String>{})[item.id] = value as String;
      case ControlType.number:
        (numbers ??= <String, double>{})[item.id] = value as double;
      case ControlType.range:
        (ranges ??= <String, RangeValuesX>{})[item.id] = value as RangeValuesX;
      case ControlType.date:
        (dateTimes ??= <String, DateTime>{})[item.id] = value as DateTime;
      case ControlType.dateRange:
        (dateTimeRanges ??= <String, DateTimeRangeX>{})[item.id] =
            value as DateTimeRangeX;
    }
  }
}
