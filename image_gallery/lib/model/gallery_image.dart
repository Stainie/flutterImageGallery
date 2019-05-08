import 'comment.dart';

class GalleryImage {
  String _file;
  DateTime _timeTaken;
  List<Comment> _comments;

  GalleryImage(this._file, this._timeTaken, this._comments);

  String get file => _file;
  DateTime get timeTaken => _timeTaken;
  List<Comment> get comments => _comments;

  Map toJson() {
    return {
      "file": file,
      "timeTaken": timeTaken.toString(),
      "comments": comments
    };
  }
}