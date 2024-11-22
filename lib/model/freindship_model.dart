class FreindshipModel {
  late String _user1Id;
  late String _user2Id;
  late String _status;
  FreindshipModel(
      {required String user1Id,
      required String user2Id,
      required String status})
      : _status = status,
        _user1Id = user1Id,
        _user2Id = user2Id;
  String get getUser1Id => _user1Id;
  String get getUser2Id => _user2Id;
  String get getStatus => _status;
  Map<String, dynamic> toMap(){
      List<String> lstSortUsersId = [getUser1Id, getUser2Id]..sort();
     return {
         "user1_id": lstSortUsersId[0],
         "user2_id":lstSortUsersId[1],
         "status":getStatus
      };
  }
}
