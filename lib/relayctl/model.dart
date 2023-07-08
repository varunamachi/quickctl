// part "model.g.dart";

import 'dart:io';

class Slot {
  String name;
  String index;
  bool defaultVal;

  Slot({
    required this.name,
    required this.index,
    required this.defaultVal,
  });
}

class ServiceEntry {
  final String host;
  final int port;
  final List<InternetAddress> currentIp4;
  final List<InternetAddress> currentIp6;

  const ServiceEntry({
    required this.host,
    required this.port,
    required this.currentIp4,
    required this.currentIp6,
  });
}

class ControllerEntry {
  String address;
  List<Slot> slots = [];

  ControllerEntry({
    required this.address,
  });

  void addSlot(Slot slot) => slots.add(slot);
}
