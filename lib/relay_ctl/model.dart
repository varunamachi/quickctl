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

class ControllerEntry {
  String address;
  List<Slot> slots = [];

  ControllerEntry({
    required this.address,
  });

  void addSlot(Slot slot) => slots.add(slot);
}
