class GalleryImageServer {
  String _title;
  String _imageUrl;
  String _creatorId;

  GalleryImageServer(this._title, this._imageUrl, this._creatorId);

  String get title => _title;
  String get imageUrl => _imageUrl;
  String get creatorId => _creatorId;

  Map toJson() {
    return {
      "title": title,
      "imageUrl": imageUrl
    };
  }
}