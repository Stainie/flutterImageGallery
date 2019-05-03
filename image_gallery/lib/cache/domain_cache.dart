import 'dart:io';

import '../model/gallery_image.dart';
import '../model/user.dart';

class DomainCache {
  static List<File> galleryImages;
  static User user;
  static String token;
}