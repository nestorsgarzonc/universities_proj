import 'package:equatable/equatable.dart';

class UniversityModel extends Equatable {
  const UniversityModel({
    required this.alphaTwoCode,
    required this.domains,
    required this.country,
    required this.webPages,
    required this.name,
    this.stateProvince,
  });

  final String alphaTwoCode;
  final List<String> domains;
  final String country;
  final String? stateProvince;
  final List<String> webPages;
  final String name;

  UniversityModel copyWith({
    String? alphaTwoCode,
    List<String>? domains,
    String? country,
    String? stateProvince,
    List<String>? webPages,
    String? name,
  }) {
    return UniversityModel(
      alphaTwoCode: alphaTwoCode ?? this.alphaTwoCode,
      domains: domains ?? this.domains,
      country: country ?? this.country,
      stateProvince: stateProvince ?? this.stateProvince,
      webPages: webPages ?? this.webPages,
      name: name ?? this.name,
    );
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    return UniversityModel(
      alphaTwoCode: map['alpha_two_code'] ?? '',
      domains: List<String>.from(map['domains']),
      country: map['country'] ?? '',
      stateProvince: map['state-province'],
      webPages: List<String>.from(map['web_pages']),
      name: map['name'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UniversityModel(alpha_two_code: $alphaTwoCode, domains: $domains, country: $country, stateProvince: $stateProvince, web_pages: $webPages, name: $name)';
  }

  @override
  List<Object?> get props {
    return [
      alphaTwoCode,
      domains,
      country,
      stateProvince,
      webPages,
      name,
    ];
  }
}
