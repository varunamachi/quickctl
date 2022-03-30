import 'package:flutter/material.dart';
import 'package:quickctl/relay_ctl/mdns.dart';
import 'package:quickctl/relay_ctl/model.dart';
import 'package:quickctl/relay_ctl/widgets/discovered_controllers.dart';
import 'package:quickctl/widgets/scaffold.dart';

class DiscoverScreen extends StatefulWidget {
  static const id = "mob.relayctl.discover";

  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  Future<List<ServiceEntry>>? _discovered;

  @override
  void initState() {
    setState(() {
      _discovered = discoverControllers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QScaffold(
        appBar: AppBar(
          title: const Text("Discover Controllers"),
        ),
        body: _discovered != null
            ? DiscoveredControllers(serviceEntries: _discovered!)
            : const Text("No controller found"));
  }
}
