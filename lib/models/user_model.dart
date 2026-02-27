class UserModel {
  final String uid;
  final String name;
  final String role;
  final int? majorId;
  final List<int> coursesId;
  final List<Map<String, dynamic>> skillTags;
  final List<int> devTags;
  final String matricNo;
  final String email;
  final String whatsappNum;
  final String portfolioUrl;

  UserModel({
    required this.uid,
    this.name = '',
    this.role = 'Student',
    this.majorId,
    this.coursesId = const [],
    this.skillTags = const [],
    this.devTags = const [],
    this.matricNo = '',
    this.email = '',
    this.whatsappNum = '',
    this.portfolioUrl = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'Student',
      majorId: json['major_id'],
      coursesId: List<int>.from(json['courses_id'] ?? []),
      skillTags: List<Map<String, dynamic>>.from(json['skill_tags'] ?? []),
      devTags: List<int>.from(json['dev_tags'] ?? []),
      matricNo: json['matric_no'] ?? '',
      email: json['email'] ?? '',
      whatsappNum: json['whatsapp_num'] ?? '',
      portfolioUrl: json['portfolio_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'role': role,
        'major_id': majorId,
        'courses_id': coursesId,
        'skill_tags': skillTags,
        'dev_tags': devTags,
        'matric_no': matricNo,
        'email': email,
        'whatsapp_num': whatsappNum,
        'portfolio_url': portfolioUrl,
      };

  /// Helper: get skill tag names from resolved tags
  List<String> get skillNames =>
      skillTags.map((t) => t['name']?.toString() ?? 'Tag ${t['tag_id']}').toList();
}
