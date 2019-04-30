import 'dart:io';

import 'comment.dart';

class GalleryImage {
  File _file;
  DateTime _timeTaken;
  List<Comment> _comments;

  GalleryImage(this._file, this._timeTaken, this._comments);

  File get file => _file;
  DateTime get timeTaken => _timeTaken;
  List<Comment> get comments => _comments;
}