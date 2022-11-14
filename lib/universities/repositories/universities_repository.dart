import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universities_proj/core/failure/failure.dart';
import 'package:universities_proj/universities/data_sources/universities_data_source.dart';
import 'package:universities_proj/universities/models/university_model.dart';

final universitiesRepositoryProvider = Provider<UniversitiesRepository>((ref) {
  return UniversitiesRepositoryImpl.fromRef(ref);
});

abstract class UniversitiesRepository {
  Future<Either<Failure, List<UniversityModel>>> getUniversities();
}

class UniversitiesRepositoryImpl implements UniversitiesRepository {
  final UniversitiesDataSource universitiesDatasouce;

  UniversitiesRepositoryImpl(this.universitiesDatasouce);

  factory UniversitiesRepositoryImpl.fromRef(Ref ref) {
    return UniversitiesRepositoryImpl(ref.read(universitiesDataSourceProvider));
  }

  @override
  Future<Either<Failure, List<UniversityModel>>> getUniversities() async {
    try {
      final universities = await universitiesDatasouce.getUniversities();
      return Right(universities);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
