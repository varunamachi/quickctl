// part "model.g.dart";

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
  String host;
  int port;

  ServiceEntry({
    required this.host,
    required this.port,
  });

  String address() {
    return "$host:$port";
  }
}

class ControllerEntry {
  String address;
  List<Slot> slots = [];

  ControllerEntry({
    required this.address,
  });

  void addSlot(Slot slot) => slots.add(slot);
}
