// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogPostAdapter extends TypeAdapter<BlogPost> {
  @override
  final int typeId = 10;

  @override
  BlogPost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogPost(
      id: fields[0] as int?,
      name: fields[1] as String?,
      subTitle: fields[2] as String?,
      tags: (fields[3] as List?)?.cast<dynamic>(),
      author: fields[4] as Author?,
      createDate: fields[5] as String?,
      postDate: fields[6] as String?,
      lastEditDate: fields[7] as String?,
      lastEditBy: fields[8] as Author?,
      metaTitle: fields[9] as String?,
      metaDescription: fields[10] as String?,
      metaKeywords: fields[11] as String?,
      imageUrl: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BlogPost obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.createDate)
      ..writeByte(6)
      ..write(obj.postDate)
      ..writeByte(7)
      ..write(obj.lastEditDate)
      ..writeByte(8)
      ..write(obj.lastEditBy)
      ..writeByte(9)
      ..write(obj.metaTitle)
      ..writeByte(10)
      ..write(obj.metaDescription)
      ..writeByte(11)
      ..write(obj.metaKeywords)
      ..writeByte(12)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthorAdapter extends TypeAdapter<Author> {
  @override
  final int typeId = 11;

  @override
  Author read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Author(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Author obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
