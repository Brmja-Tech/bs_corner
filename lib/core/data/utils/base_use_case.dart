import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract class BaseUseCase<Type, Params> {
  const BaseUseCase();

  Future<Either<Failure, Type>> call(Params params);
}

abstract class NormalUseCase<Type, Params> {
  Type call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

class CommonParams extends Equatable {
  final String? id;
  final CrudBodyParams? bodyParams;

  const CommonParams({this.id, this.bodyParams})
      : assert(id != null || bodyParams != null);

  @override
  List<Object?> get props => [id, bodyParams];
}

//for requests which has body
class CrudBodyParams extends Equatable {
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  const CrudBodyParams({required this.name});

  @override
  List<Object> get props => [name];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;

  PaginationParams({this.limit = 30, required this.page}) {
    if (page < 1 || limit < 1) {
      throw Exception(
          'Invalid pagination params: page and limit must be greater than 0');
    }
  }

  Map<String, dynamic> toJson() => {
        'limit': limit,
        'page': page,
      };

  @override
  List<Object?> get props => [page, limit];
}

class UpdateParams {
  final Map<String, dynamic> updates;

  UpdateParams({
    required this.updates,
  });
}
