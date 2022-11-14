import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:universities_proj/universities/data_sources/universities_data_source.dart';
import 'package:universities_proj/universities/models/university_model.dart';
import 'package:universities_proj/universities/repositories/universities_repository.dart';

import 'universities_repository_test.mocks.dart';

@GenerateMocks([UniversitiesDataSource])
void main() {
  late UniversitiesDataSource dataSource;
  late UniversitiesRepositoryImpl repository;

  setUpAll(() {
    dataSource = MockUniversitiesDataSource();
    repository = UniversitiesRepositoryImpl(dataSource);
  });

  group('UniversitiesRepository test', () {
    test('should return an empty list of universities', () async {
      when(dataSource.getUniversities()).thenAnswer((_) => Future.value([]));
      final res = await repository.getUniversities();
      res.fold(
        (l) => expect(l, isNull),
        (r) => expect(r, []),
      );
      expect(res.isLeft(), false);
      expect(res.isRight(), true);
    });

    test('should return a list of universities', () async {
      const universities = [
        UniversityModel(
          name: 'Universidad Nacional de Colombia',
          country: 'Colombia',
          alphaTwoCode: 'CO',
          stateProvince: 'Bogotá',
          webPages: ['https://unal.edu.co'],
          domains: ['unal.edu.co'],
        ),
        UniversityModel(
          name: 'Universidad de los Andes',
          country: 'Colombia',
          alphaTwoCode: 'CO',
          stateProvince: 'Bogotá',
          webPages: ['https://uniandes.edu.co'],
          domains: ['uniandes.edu.co'],
        ),
      ];
      when(dataSource.getUniversities()).thenAnswer((_) => Future.value(universities));
      final res = await repository.getUniversities();
      res.fold(
        (l) => expect(l, isNull),
        (r) => expect(r, universities),
      );
      expect(res.isLeft(), false);
      expect(res.isRight(), true);
    });

    test('should return a failure', () async {
      when(dataSource.getUniversities()).thenThrow(Exception());
      final res = await repository.getUniversities();
      res.fold(
        (l) => expect(l, isNotNull),
        (r) => expect(r, isNull),
      );
      expect(res.isLeft(), true);
      expect(res.isRight(), false);
    });
  });
}
