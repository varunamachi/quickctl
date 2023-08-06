import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:quickctl/params/model.dart';
import 'package:quickctl/services/utils.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toggle_switch/toggle_switch.dart';

typedef ValueChangeHandler = Future<bool> Function(
    ControlItem item, dynamic value);

class ControlItemList extends StatefulWidget {
  final List<ControlItem> items;
  final ControlValues values;
  final ValueChangeHandler handler;

  const ControlItemList({
    required this.items,
    required this.values,
    required this.handler,
    super.key,
  });

  @override
  State<ControlItemList> createState() => _ControlItemListState();
}

class _ControlItemListState extends State<ControlItemList> {
  @override
  Widget build(BuildContext ctx) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return switch (item.type) {
          ControlType.constant => _buildConstantWidget(ctx, item),
          ControlType.boolean => _buildBooleanWidget(ctx, item),
          ControlType.tristate => _buildTristateWidget(ctx, item),
          ControlType.choice => _buildChoiceWidget(ctx, item),
          ControlType.number => _buildNumberWidget(ctx, item),
          ControlType.range => _buildRangeWidget(ctx, item),
          ControlType.date => _buildDateWidget(ctx, item),
          ControlType.dateRange => _buildDateRangeWidget(ctx, item),
        };
      },
    );
  }

  Widget _buildConstantWidget(BuildContext ctx, ControlItem item) {
    return wrap(ctx, item,
        value: Text(
          item.props.constVal ?? '<invalid>',
          style: GoogleFonts.firaCode(),
        ));
  }

  Widget _buildBooleanWidget(BuildContext ctx, ControlItem item) {
    var value = widget.values.getBool(item);
    final trueLabel = item.props.boolOpts?.trueLabel ?? 'On';
    final falseLabel = item.props.boolOpts?.falseLabel ?? 'Off';
    var boolWidget = ToggleSwitch(
      initialLabelIndex: value ? 0 : 1,
      totalSwitches: 2,
      labels: [
        trueLabel,
        falseLabel,
      ],
      onToggle: (index) async => await setValue(item, index == 0),
    );

    return wrap(ctx, item, ctrlr: boolWidget);
  }

  Widget _buildTristateWidget(BuildContext ctx, ControlItem item) {
    final value = widget.values.getTristate(item);
    final trueLabel = item.props.tristateOpts?.trueLabel ?? 'On';
    final falseLabel = item.props.tristateOpts?.falseLabel ?? 'Off';
    final noneLabel = item.props.tristateOpts?.noneLabel ?? 'None';

    final tristateWidget = ToggleSwitch(
      initialLabelIndex: switch (value) {
        Tristate.on => 0,
        Tristate.off => 1,
        Tristate.none => 2,
      },
      totalSwitches: 3,
      labels: [
        trueLabel,
        falseLabel,
        noneLabel,
      ],
      onToggle: (index) async {
        await setValue(
            item,
            switch (index) {
              0 => Tristate.on,
              1 => Tristate.off,
              _ => Tristate.none,
            });
      },
    );

    return wrap(ctx, item, ctrlr: tristateWidget);
  }

  Widget _buildChoiceWidget(BuildContext ctx, ControlItem item) {
    final selected = widget.values.getOption(item);
    if (selected == null) {
      return wrap(ctx, item, value: const Text('<invalid>'));
    }

    final combo = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButton(
        isExpanded: true,
        value: selected.value,
        items: [
          for (Option opt in item.props.options)
            DropdownMenuItem<String>(
              value: opt.value,
              child: Text(opt.name),
            )
        ],
        onChanged: (val) async => await setValue(item, val),
      ),
    );

    return wrap(ctx, item, ctrlr: combo);
  }

  Widget _buildNumberWidget(BuildContext ctx, ControlItem item) {
    final rangeStart = item.props.range?.start ?? 0;
    final rangeEnd = item.props.range?.end ?? 10.0;

    final value = widget.values.getNumber(item);
    final paramWidget = Slider(
      value: value,
      min: rangeStart,
      max: rangeEnd,
      label: "$value",
      divisions: item.props.range?.divs ?? 1,
      onChanged: (newVal) => {
        setState(() {
          widget.values.setValue(item, newVal);
        })
      },
      onChangeEnd: (val) async => await setValue(item, val),
    );

    return wrap(ctx, item,
        ctrlr: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("$rangeStart", style: GoogleFonts.firaCode()),
            Expanded(child: paramWidget),
            Text("$rangeEnd", style: GoogleFonts.firaCode()),
          ],
        ));
  }

  Widget _buildRangeWidget(BuildContext ctx, ControlItem item) {
    final rangeEnd = item.props.range?.end ?? 100.0;
    final rangeStart = item.props.range?.start ?? 0;

    final value = widget.values.getRange(item);
    final paramWidget = RangeSlider(
      values: value,
      min: rangeStart,
      max: rangeEnd,
      divisions: item.props.range?.divs ?? 1,
      labels: RangeLabels(
        "${value.start}",
        "${value.end}",
      ),
      onChanged: (val) {
        setState(() {
          widget.values.setValue(item, RangeValuesX.fromRangeValues(val));
        });
      },
      onChangeEnd: (val) async =>
          await setValue(item, RangeValuesX.fromRangeValues(val)),
    );

    return wrap(
      ctx,
      item,
      ctrlr: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$rangeStart", style: GoogleFonts.firaCode()),
          Expanded(child: paramWidget),
          Text("$rangeEnd", style: GoogleFonts.firaCode()),
        ],
      ),
    );
  }

  Widget _buildDateWidget(BuildContext ctx, ControlItem item) {
    final range = item.props.dateRange ?? DateRange.empty();
    final value = widget.values.getDateTime(item);

    final paramWidget = IconButton(
      onPressed: () async {
        final dateTime = await showOmniDateTimePicker(
          context: ctx,
          initialDate: value,
          firstDate: range.start,
          lastDate: range.end,
        );
        await setValue(item, dateTime);
      },
      icon: const Icon(Icons.calendar_month),
    );

    return wrap(ctx, item,
        ctrlr: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("y-MM-dd HH:mm:ss").format(value),
              style: GoogleFonts.firaCode(),
            ),
            paramWidget
          ],
        ));
  }

  Widget _buildDateRangeWidget(BuildContext ctx, ControlItem item) {
    final range = item.props.dateRange ?? DateRange.empty();
    final values = widget.values.getDateTimeRange(item);

    final paramWidget = IconButton(
      onPressed: () async {
        final dateTime = await showOmniDateTimeRangePicker(
          context: ctx,
          startInitialDate: values.start,
          endInitialDate: values.end,
          startFirstDate: range.start,
          endLastDate: range.end,
        );
        var selected = <DateTime>[DateTime.now(), DateTime.now()];
        if (dateTime != null && dateTime.length == 2) {
          selected = dateTime;
        }
        await setValue(item, DateTimeRangeX(selected[0], selected[1]));
      },
      icon: const Icon(Icons.date_range_outlined),
    );

    final start = DateFormat("y-MM-dd HH:mm:ss").format(values.start);
    final end = DateFormat("y-MM-dd HH:mm:ss").format(values.end);

    return wrap(ctx, item,
        ctrlr: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  start,
                  style: GoogleFonts.firaCode(),
                ),
                Text(
                  end,
                  style: GoogleFonts.firaCode(),
                ),
              ],
            ),
            paramWidget,
          ],
        ));
  }

  Future<void> setValue(ControlItem item, dynamic value) async {
    final res = await widget.handler(item, value);
    if (!res) {
      // Show error
      return;
    }

    setState(() {
      widget.values.setValue(item, value);
    });
  }

  Widget wrap(BuildContext ctx, ControlItem item,
      {Widget? ctrlr, Widget? value}) {
    final theme = Theme.of(ctx);

    final big = ResponsiveBreakpoints.of(ctx).largerThan(TABLET);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.name,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  item.desc,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                      fontStyle: FontStyle.italic, color: theme.hintColor),
                ),
              ),
              if (big && value != null) Flexible(child: value),
              if (big && ctrlr != null) Flexible(child: ctrlr),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (!big && value != null) value,
          if (!big && ctrlr != null) ctrlr,
          const Divider(),
        ],
      ),
    );
  }
}
