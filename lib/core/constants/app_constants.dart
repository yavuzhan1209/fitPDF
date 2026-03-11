enum CompressionLevel {
  light,
  balanced,
  maximum;

  double get ratio {
    switch (this) {
      case light:    return 0.75;
      case balanced: return 0.45;
      case maximum:  return 0.20;
    }
  }

  int get imageQuality {
    switch (this) {
      case light:    return 85;
      case balanced: return 60;
      case maximum:  return 35;
    }
  }

  String get emoji {
    switch (this) {
      case light:    return '🪶';
      case balanced: return '⚡';
      case maximum:  return '💎';
    }
  }
}

