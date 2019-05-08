import 'dart:io';

import '../model/gallery_image.dart';
import '../model/gallery_image_server.dart';
import '../model/user.dart';

class DomainCache {
  static List<GalleryImage> galleryImages;
  static List<GalleryImageServer> galleryImagesServer;
  static User user;
  static String token;
}