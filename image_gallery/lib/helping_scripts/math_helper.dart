import 'dart:math' as math;

class MathHelper {
  static double lerpDouble(a, b, t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }

  static String calculateDistance(
      double latOne, double latTwo, double lonOne, double lonTwo) {
    var r = 6371; // Radius of the earth in km
    var dLat = _deg2rad(latOne - latTwo); // deg2rad below
    var dLon = _deg2rad(lonOne - lonTwo);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(latOne)) *
            math.cos(_deg2rad(latTwo)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = r * c; // Distance in km
    return (d / 1.6).toStringAsPrecision(3) + " miles away";
  }

  static double _deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}
