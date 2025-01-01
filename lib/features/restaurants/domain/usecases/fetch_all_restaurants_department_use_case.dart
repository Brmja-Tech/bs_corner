import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/models/restaurant_model.dart';
import 'package:pscorner/features/restaurants/domain/repositories/restaurants_repository.dart';

class FetchAllRestaurantsDepartmentUseCase extends BaseUseCase<List<RestaurantModel>, NoParams>{
  final RestaurantsRepository _restaurantsRepository;

  FetchAllRestaurantsDepartmentUseCase(this._restaurantsRepository);

  @override
  Future<Either<Failure, List<RestaurantModel>>> call(NoParams params) {
    return _restaurantsRepository.fetchAllItems(params);
  }
}