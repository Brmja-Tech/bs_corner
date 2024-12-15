import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';

class InsertRestaurantItemUseCase extends BaseUseCase<int, InsertItemParams> {
  final RestaurantDataSource _restaurantRepository;

  InsertRestaurantItemUseCase(this._restaurantRepository);

  @override
  Future<Either<Failure, int>> call(InsertItemParams params) {
    return _restaurantRepository.insertItem(params);
  }
}
