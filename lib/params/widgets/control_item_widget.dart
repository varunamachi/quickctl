import 'package:flutter/material.dart';
import 'package:quickctl/params/model.dart';

class ControlWidget extends StatefulWidget {
  final List<ControlItem> items;
  final ControlValues values;

  const ControlWidget({required this.items, required this.values, super.key});

  @override
  State<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];

    for (var item in widget.items) {
      // widgets.add()
      final widget = switch (item.type) {
        ControlType.constant => Text(item.props.constVal ?? ''),
        ControlType.boolean => _buildBooleanWidget(context, item),
        ControlType.choice => const Text(""),
        ControlType.range => const Text(""),
        ControlType.date => const Text(""),
        ControlType.dateRange => Container(),
      };
    }

    return Container();
  }

  Widget _buildBooleanWidget(BuildContext ctx, ControlItem item) {
    if (item.props.boolOpts == null) {
      return Switch(value: true, onChanged: (val) => {});
    }
    return DropdownButton(items: null, onChanged: (val) => {});
  }

  Widget _buildChoiceWidget(BuildContext ctx, ControlItem item) {
    return DropdownButton(items: null, onChanged: (val) => {});
  }
}
