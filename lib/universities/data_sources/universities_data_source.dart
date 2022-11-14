import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universities_proj/core/external/api_handler.dart';
import 'package:universities_proj/core/logger/logger.dart';
import 'package:universities_proj/universities/models/university_model.dart';

final universitiesDataSourceProvider = Provider<UniversitiesDataSource>((ref) {
  return UniversitiesDataSourceImpl.fromRef(ref);
});

abstract class UniversitiesDataSource {
  Future<List<UniversityModel>> getUniversities();
}

class UniversitiesDataSourceImpl implements UniversitiesDataSource {
  final ApiHandler apiHandler;

  UniversitiesDataSourceImpl(this.apiHandler);

  factory UniversitiesDataSourceImpl.fromRef(Ref ref) {
    return UniversitiesDataSourceImpl(ref.read(apiHandlerProvider));
  }

  @override
  Future<List<UniversityModel>> getUniversities() async {
    try {
      const url = '/FE-Engineer-test/universities.json';
      final response = await apiHandler.get(url);
      return (response.responseList as List).map((e) => UniversityModel.fromMap(e)).toList();
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
