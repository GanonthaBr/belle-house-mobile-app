enum ContentType {
  land(13),
  property(11);

  const ContentType(this.id);
  final int id;

  // Helper method to get content type by model name
  static ContentType? fromModelName(String modelName) {
    switch (modelName.toLowerCase()) {
      case 'land':
        return ContentType.land;
      case 'property':
        return ContentType.property;

      default:
        return null;
    }
  }
}
