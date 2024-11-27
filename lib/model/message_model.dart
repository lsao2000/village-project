class MessageModel {
  late final String _messageId;
  late final String _senderId;
  late final String _text;
  late final DateTime _sendingAt;
  MessageModel(
      {required String messageId,
      required String senderId,
      required String text,
      required DateTime sendingTime})
      : _messageId = messageId,
        _sendingAt = sendingTime,
        _text = text,
        _senderId = senderId;
  MessageModel.toAddInFirestore(
      {required String senderId,
      required String text,
      required DateTime sendingTime})
      : _sendingAt = sendingTime,
        _text = text,
        _senderId = senderId;

  MessageModel.fromQuerySnapshot(
      {required String messageId,
      required String senderId,
      required String text,
      required DateTime sendingTime})
      : _messageId = messageId,
        _sendingAt = sendingTime,
        _text = text,
        _senderId = senderId;
  Map<String, dynamic> toMap() {
    return {"senderId": _senderId, "msgText": _text, "sendingTime": _sendingAt};
  }

  String get getMessageDoc => _messageId;
  String get getSenderId => _senderId;
  String get getTextMsg => _text;
  DateTime get getSendingTime => _sendingAt;
}
