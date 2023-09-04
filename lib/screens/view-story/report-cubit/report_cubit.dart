import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/auth/auth_bloc.dart';
import '/enums/report_post.dart';
import '/models/report.dart';
import '/repositories/story/story_repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final StoryRepository _storyRepository;
  final AuthBloc _authBloc;

  ReportCubit({
    required StoryRepository storyRepository,
    required AuthBloc authBloc,
  })  : _storyRepository = storyRepository,
        _authBloc = authBloc,
        super(ReportState.initial());

  void changeReport(ReportPost? value, Report? report) {
    emit(state.copyWith(reportPost: value, report: report));
  }

  void reportPost({required Report? report, required String? storyId}) async {
    _storyRepository.reportPost(
      userId: _authBloc.state.user?.uid,
      postId: storyId,
      report: report,
    );
  }
}
