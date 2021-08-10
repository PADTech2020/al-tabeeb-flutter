import 'dart:convert';

class MedicalCenter {
  final int id;
  final String name;
  final String description;
  final String content;
  final String image;
  final String createdAt;
  final String updatedAt;
  MedicalCenter({
    this.id,
    this.name,
    this.description,
    this.content,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  MedicalCenter copyWith({
    int id,
    String name,
    String description,
    String content,
    String image,
    String createdAt,
    String updatedAt,
  }) {
    return MedicalCenter(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory MedicalCenter.fromMap(Map<String, dynamic> map) {
    return MedicalCenter(
      id: map['id']?.toInt(),
      name: map['name'],
      description: map['description'],
      content: map['content'],
      image: map['image'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalCenter.fromJson(String source) => MedicalCenter.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicalCenter(id: $id, name: $name, description: $description, content: $content, image: $image, created_at: $createdAt, updated_at: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicalCenter &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.content == content &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ description.hashCode ^ content.hashCode ^ image.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
