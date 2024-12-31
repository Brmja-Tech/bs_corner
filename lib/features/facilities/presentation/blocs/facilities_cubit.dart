import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/facilities/data/datasources/facilities_data_source.dart';
import 'facilities_state.dart';

class FacilitiesCubit extends Cubit<FacilitiesState> {
  FacilitiesCubit(this._facilitiesDataSource) : super(FacilitiesState());
  final FacilitiesDataSource _facilitiesDataSource;

  Future<Either<Failure, String>> addFacility({required String title}) async {
    // loading state
    emit(FacilitiesAddLoading());

    return _facilitiesDataSource.insertFacility(title: title).then((value) {
      return value.fold((l) {
        // failure state
        emit(FacilitiesAddFailure(l.message));

        return Left(l);
      }, (r) {
        // success state
        emit(FacilitiesAdded());

        return Right(r);
      });
    });
  }
}
