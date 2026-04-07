class Prompt {
  final String text;
  final String? imageUrl;
  final DateTime timestamp;
  final bool isLoading;

  Prompt({
    required this.text,
    this.imageUrl,
    this.isLoading=false
    }):timestamp=DateTime.now();
}
