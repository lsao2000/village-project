class PostModel {
  String _name;
  String _date;
  String _description;
  String _tag;
  int _like;
  int _dislike;
  bool _isLike;
  bool _isDislike;
  PostModel(
      {required String name,
      required String date,
      required String description,
      required String tag,
      required int dislike,
      required int like,
      required bool isLike,
      required bool isDislike})
      : _name = name,
        _date = date,
        _description = description,
        _tag = tag,
        _like = like,
        _dislike = dislike,
        _isLike = isLike,
        _isDislike = isDislike;
  set setName(String name) {
    _name = name;
  }

  set setDate(String date) {
    _date = date;
  }

  set setDescription(String description) {
    _description = description;
  }

  set setTag(String tag) {
    _tag = tag;
  }

  set setLike(int like) {
    _like = like;
  }

  set setDislike(int dislike) {
    _dislike = dislike;
  }

  set setIsLike(bool isLike) {
    _isLike = isLike;
  }

  set setIsDislike(bool isDislike) {
    _isDislike = isDislike;
  }

  get getName => _name;
  get getDate => _date;
  get getDescription => _description;
  get getTag => _tag;
  get getLike => _like;
  get getDislike => _dislike;
  get getIsLike => _isLike;
  get getIsDislike => _isDislike;
}
