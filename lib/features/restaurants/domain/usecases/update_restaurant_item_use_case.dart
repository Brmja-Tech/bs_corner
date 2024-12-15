import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/domain/repositories/restaurants_repository.dart';

class UpdateRestaurantItemUseCase extends BaseUseCase<int, UpdateItemParams>{
  final RestaurantsRepository _restaurantsRepository;

  UpdateRestaurantItemUseCase(this._restaurantsRepository);

  @override
  Future<Either<Failure, int>> call(UpdateItemParams params) {
    return _restaurantsRepository.updateItem(params);
  }
}