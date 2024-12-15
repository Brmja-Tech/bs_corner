import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';

class DeleteRestaurantItemUseCase extends BaseUseCase<int,int>{
  final RestaurantDataSource _repository;

  DeleteRestaurantItemUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(int params) async {
    return await _repository.deleteItem(params);
  }
}