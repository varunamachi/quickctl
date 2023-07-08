class RelayControllerException implements Exception {
  String msg;
  RelayControllerException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
