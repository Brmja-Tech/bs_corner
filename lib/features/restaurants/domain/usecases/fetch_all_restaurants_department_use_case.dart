import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/domain/repositories/restaurants_repository.dart';

class FetchAllRestaurantsDepartmentUseCase extends BaseUseCase<List<Map<String, dynamic>>, NoParams>{
  final RestaurantsRepository _restaurantsRepository;

  FetchAllRestaurantsDepartmentUseCase(this._restaurantsRepository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return _restaurantsRepository.fetchAllItems(params);
  }
}