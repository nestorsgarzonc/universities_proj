part of 'universities_provider.dart';

class UniversitiesState extends Equatable {
  const UniversitiesState({required this.universities});

  factory UniversitiesState.initial() => UniversitiesState(universities: StateAsync.initial());

  final StateAsync<List<UniversityModel>> universities;

  bool get isEmpty => universities.data?.isEmpty ?? true;

  @override
  List<Object> get props => [universities];

  UniversitiesState copyWith({
    StateAsync<List<UniversityModel>>? universities,
  }) {
    return UniversitiesState(universities: universities ?? this.universities);
  }
}
