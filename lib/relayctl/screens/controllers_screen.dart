import 'package:flutter/material.dart';
import 'package:quickctl/params/widgets/control_widget.dart';
import 'package:quickctl/relayctl/widgets/selected_controllers.dart';
import 'package:quickctl/widgets/scaffold.dart';

class ControllersScreen extends StatelessWidget {
  static const id = "mob.relayctl.controllers";

  const ControllersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QScaffold(
        appBar: AppBar(
          title: const Text("Controllers"),
        ),
        body: const ControlWidget());
  }
}
