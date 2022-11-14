import 'package:equatable/equatable.dart';
import 'package:universities_proj/core/external/api_response.dart';

class ApiException extends Equatable {
  const ApiException(this.response);
  final ApiResponse response;

  @override
  List<Object?> get props => [response];
}
