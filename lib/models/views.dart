import 'dart:convert';
import 'package:equatable/equatable.dart';
import '/models/app_user.dart';

class Views extends Equatable {
  final int? viewsCount;
  final List<AppUser?> viewers;

  const Views({
    this.viewsCount,
    required this.viewers,
  });

  Views copyWith({
    int? viewsCount,
    List<AppUser?>? viewers,
  }) {
    return Views(
      viewsCount: viewsCount ?? this.viewsCount,
      viewers: viewers ?? this.viewers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'viewsCount': viewsCount,
      'viewers': viewers.map((x) => x?.toMap()).toList(),
    };
  }

  factory Views.fromMap(Map<String, dynamic> map) {
    return Views(
      viewsCount: map['viewsCount']?.toInt(),
      viewers:
          List<AppUser?>.from(map['viewers']?.map((x) => AppUser.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Views.fromJson(String source) => Views.fromMap(json.decode(source));

  @override
  String toString() => 'Views(viewsCount: $viewsCount, viewers: $viewers)';

  @override
  List<Object?> get props => [viewsCount, viewers];
}
