import 'comment.dart';

class GalleryImageServer {
  String _uuid;
  String _title;
  String _imageUrl;
  String _creatorId;
  List<Comment> _comments;

  GalleryImageServer(this._title, this._imageUrl) {
    _comments = new List<Comment>();
  }

  String get uuid => _uuid;
  String get title => _title;
  String get imageUrl => _imageUrl;
  String get creatorId => _creatorId;
  List<Comment> get comments => _comments;

  void setUuid(String uuid) {
    this._uuid = uuid;
  }

  Map toJson() {
    return {
      "title": title,
      "imageUrl": imageUrl
    };
  }
}