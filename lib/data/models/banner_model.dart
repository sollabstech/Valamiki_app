class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String targetType; // category, product, url
  final String targetId;
  final bool isActive;
  final int sortOrder;

  BannerModel({
    required this.id,
    required this.imageUrl,
    this.title = '',
    this.subtitle = '',
    this.targetType = 'category',
    this.targetId = '',
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map, String id) {
    return BannerModel(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      targetType: map['targetType'] ?? 'category',
      targetId: map['targetId'] ?? '',
      isActive: map['isActive'] ?? true,
      sortOrder: map['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'targetType': targetType,
      'targetId': targetId,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}
