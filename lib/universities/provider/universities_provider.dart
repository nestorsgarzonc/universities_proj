import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universities_proj/core/wrappers/state_wrapper.dart';
import 'package:universities_proj/universities/models/university_model.dart';
import 'package:universities_proj/universities/repositories/universities_repository.dart';
part 'universities_state.dart';

final universitiesProvider = StateNotifierProvider<UniversitiesNotifier, UniversitiesState>((ref) {
  return UniversitiesNotifier.fromRef(ref);
});

class UniversitiesNotifier extends StateNotifier<UniversitiesState> {
  UniversitiesNotifier(this.ref, this.universitiesRepository) : super(UniversitiesState.initial());

  final UniversitiesRepository universitiesRepository;
  final Ref ref;

  factory UniversitiesNotifier.fromRef(Ref ref) {
    return UniversitiesNotifier(ref, ref.read(universitiesRepositoryProvider));
  }

  Future<void> getUniversities() async {
    state = state.copyWith(universities: StateAsync.loading());
    final universities = await universitiesRepository.getUniversities();
    state = universities.fold(
      (l) => state.copyWith(universities: StateAsync.error(l)),
      (r) => state.copyWith(universities: StateAsync.success(r)),
    );
  }
}
