import 'package:uuid/uuid.dart';

class IdeaModel {
  final String id;
  final String title;
  final String tagline;
  final String description;
  final int rating;
  final int voteCount;
  final DateTime submittedAt;

  IdeaModel({
    required this.title,
    required this.tagline,
    required this.description,
    required this.rating,
    this.voteCount = 0,
    String? id,
    DateTime? submittedAt,
  }) : id = id ?? const Uuid().v4(),
       submittedAt = submittedAt ?? DateTime.now();

  IdeaModel copyWith({int? voteCount}) {
    return IdeaModel(
      id: id,
      title: title,
      tagline: tagline,
      description: description,
      rating: rating,
      voteCount: voteCount ?? this.voteCount,
      submittedAt: submittedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tagline': tagline,
      'description': description,
      'rating': rating,
      'voteCount': voteCount,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory IdeaModel.fromJson(Map<String, dynamic> json) {
    return IdeaModel(
      id: json['id'],
      title: json['title'],
      tagline: json['tagline'],
      description: json['description'],
      rating: json['rating'],
      voteCount: json['voteCount'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }
}
