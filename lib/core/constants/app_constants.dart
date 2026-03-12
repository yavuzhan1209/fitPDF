enum CompressionLevel {
  smart,
  maximum;

  double get ratio {
    switch (this) {
      case smart:   return 0.45;
      case maximum: return 0.20;
    }
  }

  int get imageQuality {
    switch (this) {
      case smart:   return 65;
      case maximum: return 35;
    }
  }

  String get emoji {
    switch (this) {
      case smart:   return '⚡';
      case maximum: return '💎';
    }
  }
}
