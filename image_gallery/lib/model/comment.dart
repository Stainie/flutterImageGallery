class Comment {
  String _text;
  DateTime _timeWritten;
  String _writer;
  String _imageId;

  Comment(this._text, this._timeWritten, this._writer, this._imageId);

  String get text => _text;
  DateTime get timeWritten => _timeWritten;
  String get writter => _writer;
  String get imageId => _imageId;
}