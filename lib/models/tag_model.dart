class TagModel {
  final String id;
  final String name;
  final int categoryId; // 0=Major, 1=Course, 2=Skill, 3=Dev Area

  TagModel({required this.id, required this.name, required this.categoryId});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['tag_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }

  String get categoryLabel {
    switch (categoryId) {
      case 0:
        return 'Major';
      case 1:
        return 'Course';
      case 2:
        return 'Skill';
      case 3:
        return 'Dev Area';
      default:
        return 'Other';
    }
  }
}
