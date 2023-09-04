import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';

import 'package:viewstories/enums/enums.dart';

class Report extends Equatable {
  final String reportString;
  final ReportPost reportPost;

  const Report({
    required this.reportString,
    required this.reportPost,
  });

  Report copyWith({
    String? reportString,
    ReportPost? reportPost,
  }) {
    return Report(
      reportString: reportString ?? this.reportString,
      reportPost: reportPost ?? this.reportPost,
    );
  }

  Map<String, dynamic> toMap() {
    final report = EnumToString.convertToString(reportPost);
    return {
      'reportString': reportString,
      'reportPost': report,
    };
  }

  // factory Report.fromMap(Map<String, dynamic> map) {
  //   return Report(
  //     reportString: map['reportString'],
  //     reportPost: ReportPost.fromMap(map['reportPost']),
  //   );
  // }

  //String toJson() => json.encode(toMap());

  //factory Report.fromJson(String source) => Report.fromMap(json.decode(source));

  @override
  String toString() =>
      'Report(reportString: $reportString, reportPost: $reportPost)';

  @override
  List<Object?> get props => [reportString, reportPost];
}
