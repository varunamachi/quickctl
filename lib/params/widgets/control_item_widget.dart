import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:quickctl/params/model.dart';

typedef ValueChangeHandler = Function(ControlItem item, dynamic value);

class ControlWidget extends StatefulWidget {
  final List<ControlItem> items;
  final ControlValues values;
  final ValueChangeHandler handler;

  const ControlWidget({
    required this.items,
    required this.values,
    required this.handler,
    super.key,
  });

  @override
  State<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  @override
  Widget build(BuildContext ctx) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return switch (item.type) {
          ControlType.constant => Text(item.props.constVal ?? ''),
          ControlType.boolean => _buildBooleanWidget(ctx, item),
          ControlType.choice => _buildChoiceWidget(ctx, item),
          ControlType.number => _buildNumberWidget(ctx, item),
          ControlType.range => _buildRangeWidget(ctx, item),
          ControlType.date => _buildDateWidget(ctx, item),
          ControlType.dateRange => _buildDateRangeWidget(ctx, item),
        };
      },
    );
  }

  Widget _buildBooleanWidget(BuildContext ctx, ControlItem item) {
    if (item.props.boolOpts == null) {
      return SwitchListTile(
        dense: true,
        title: Text(item.id),
        subtitle: Text(item.desc),
        value: widget.values.getBool(item.id),
        onChanged: (val) => {},
      );
    }
    return DropdownButton(
      value: widget.values.getBool(item.id),
      items: [
        DropdownMenuItem<bool>(
          value: true,
          child: Text(item.props.boolOpts?.trueLabel ?? 'On'),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text(item.props.boolOpts?.falseLabel ?? 'Off'),
        ),
        if ((item.props.boolOpts?.noneLabel ?? '') != '')
          DropdownMenuItem<bool>(
            value: null,
            child: Text(item.props.boolOpts?.noneLabel ?? 'Any'),
          )
      ],
      onChanged: (val) => {},
    );
  }

  Widget _buildChoiceWidget(BuildContext ctx, ControlItem item) {
    return DropdownButton(
      value: widget.values.getString(item.id),
      items: [
        for (Option opt in item.props.options)
          DropdownMenuItem<String>(
            value: widget.values.getString(opt.value),
            child: Text(opt.name),
          )
      ],
      onChanged: (val) => {},
    );
  }

  Widget _buildNumberWidget(BuildContext ctx, ControlItem item) {
    return Slider(
      value: widget.values.getNumber(item.id),
      max: item.props.range?.end ?? 10.0,
      min: item.props.range?.start ?? 0,
      divisions: item.props.range?.divs ?? 1,
      onChanged: (_) => {},
      onChangeEnd: (val) => widget.handler(item, val),
    );
  }

  Widget _buildRangeWidget(BuildContext ctx, ControlItem item) {
    return RangeSlider(
      values: widget.values.getRange(item.id),
      max: item.props.range?.end ?? 100.0,
      min: item.props.range?.start ?? 0,
      divisions: item.props.range?.divs ?? 1,
      onChanged: (_) => {},
      onChangeEnd: (val) => widget.handler(item, val),
    );
  }

  Widget _buildDateWidget(BuildContext ctx, ControlItem item) {
    final range = item.props.dateRange ?? DateRange.empty();

    return IconButton(
      onPressed: () async {
        final dateTime = await showOmniDateTimePicker(
          context: ctx,
          initialDate: widget.values.getDateTime(item.id),
          firstDate: range.start,
          lastDate: range.end,
        );
        widget.handler(item, dateTime);
      },
      icon: const Icon(Icons.calendar_month),
    );
  }

  Widget _buildDateRangeWidget(BuildContext ctx, ControlItem item) {
    final range = item.props.dateRange ?? DateRange.empty();
    final values = widget.values.getDateTimeRange(item.id);

    return IconButton(
      onPressed: () async {
        final dateTime = await showOmniDateTimeRangePicker(
          context: ctx,
          startInitialDate: values.start,
          endInitialDate: values.end,
          startFirstDate: range.start,
          endLastDate: range.end,
        );
        var selected = DateRange.empty();
        if (dateTime != null && dateTime.length == 2) {
          selected = DateRange(start: dateTime[0], end: dateTime[1]);
        }
        widget.handler(item, selected);
      },
      icon: const Icon(Icons.date_range_outlined),
    );
  }
}
