/// Represents a single AI-generated image creation.
class Creation {
  final String id;
  final String prompt;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isFavorite;

  const Creation({
    required this.id,
    required this.prompt,
    this.imageUrl,
    required this.createdAt,
    this.isFavorite = false,
  });

  Creation copyWith({
    String? id,
    String? prompt,
    String? imageUrl,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Creation(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
