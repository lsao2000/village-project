class IghoumaneUser {
  late final String _userId;
  late final String _firstName;
  late final String _lastName;
  late final String _phoneNumber;
  late final DateTime _createdAt;
  late final String _password;
  IghoumaneUser({
    //required String userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime createAt,
    required String password,
  });
  Map<String, dynamic> toMap() {
    return {
      "user_id": _userId,
      "firstName": _firstName,
      "lastName": _lastName,
      "phoneNumber": _phoneNumber,
      "password":_password,
      "createdAt": _createdAt
    };
  }
  set setUserId(String userId){
      _userId = userId;
  }

  String get getPassword => _password;
  String get getUserId => _userId;
  String get getFirstName => _firstName;
  String get getLastName => _lastName;
  String get getPhoneNumber => _phoneNumber;
  DateTime get getCreatedDate => _createdAt;
}
