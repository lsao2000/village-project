
class JoinedUser {
    late String _userId;
    late String _first_name;
    late String _last_name;
    late String _phone_number;
    late DateTime _created_at;
    JoinedUser({required String userId, required String firstName, required String lastName, required String phoneNumber, required DateTime createAt}) :
        _userId = userId, _first_name = firstName, _last_name = lastName, _phone_number = phoneNumber, _created_at = createAt;
    Map<String, dynamic> toMap() {
        return {
            "":""
        };
    }
}
