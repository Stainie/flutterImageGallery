class Comment {
  String _text;
  DateTime _timeWritten;
  String _writer;

  Comment(this._text, this._timeWritten, this._writer);

  String get text => _text;
  DateTime get timeWritten => _timeWritten;
  String get writter => _writer;
}