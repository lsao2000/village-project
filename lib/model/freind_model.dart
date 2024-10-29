class FreindModel {
  String _name;
  String _message;
  int _notifcationMessageCount;
  FreindModel(
      {required String name,
      required String message,
      required int notifcationMessageCount})
      : _name = name,
        _message = message,
        _notifcationMessageCount = notifcationMessageCount;
  String get getName => _name;
  String get getMessage => _message;
  int get getNotificationMessageCount => _notifcationMessageCount;
}
