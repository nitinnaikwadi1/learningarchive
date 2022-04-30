class InteractItem {
  String text;
  String audio;

  InteractItem({required this.text, required this.audio});

  @override
  String toString() {
    return '{text: $text, audio: $audio}';
  }
}
