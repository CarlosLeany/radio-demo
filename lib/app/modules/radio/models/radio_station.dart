class RadioStation {
  final String id;
  final String name;
  final String url;
  final String? description;
  final String? logoUrl;

  const RadioStation({
    required this.id,
    required this.name,
    required this.url,
    this.description,
    this.logoUrl,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioStation && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
