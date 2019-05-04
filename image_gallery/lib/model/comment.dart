class Comment {
  String _text;
  DateTime _timeWritten;
  String _writer;
  String _imageId;

  Comment(this._text, this._timeWritten, this._writer);

  String get text => _text;
  DateTime get timeWritten => _timeWritten;
  String get writter => _writer;
  String get imageId => _imageId;

  void setImageId(String imageId) {
    this._imageId = imageId;
  }

  Map toJson() {
    return {
      "text": text,
      "timeWritten": timeWritten.toString(),
      "writter": writter
    };
  }
}