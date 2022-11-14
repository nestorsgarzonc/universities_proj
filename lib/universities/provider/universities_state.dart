part of 'universities_provider.dart';

class UniversitiesState extends Equatable {
  const UniversitiesState({
    required this.universities,
    this.paginatedList = const [],
    this.isGettingMore = false,
  });

  factory UniversitiesState.initial() => UniversitiesState(universities: StateAsync.initial());

  final StateAsync<List<UniversityModel>> universities;
  final List<UniversityModel> paginatedList;
  final bool isGettingMore;

  int get totalLength => universities.data?.length ?? 0;
  bool get isEmpty => universities.data?.isEmpty ?? true;

  @override
  List<Object> get props => [universities, paginatedList, isGettingMore];

  UniversitiesState copyWith({
    StateAsync<List<UniversityModel>>? universities,
    List<UniversityModel>? paginatedList,
    bool? isGettingMore,
  }) {
    return UniversitiesState(
      universities: universities ?? this.universities,
      paginatedList: paginatedList ?? this.paginatedList,
      isGettingMore: isGettingMore ?? this.isGettingMore,
    );
  }
}
