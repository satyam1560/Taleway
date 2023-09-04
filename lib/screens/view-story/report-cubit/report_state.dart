part of 'report_cubit.dart';

class ReportState extends Equatable {
  final ReportPost reportPost;
  final Report? report;

  const ReportState({required this.reportPost, this.report});

  factory ReportState.initial() =>
      const ReportState(reportPost: ReportPost.sexualContent);

  ReportState copyWith({
    ReportPost? reportPost,
    Report? report,
  }) {
    return ReportState(
      reportPost: reportPost ?? this.reportPost,
      report: report ?? this.report,
    );
  }

  @override
  List<Object?> get props => [reportPost, report];
}
