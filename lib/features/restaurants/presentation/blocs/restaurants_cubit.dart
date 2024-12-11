import 'package:flutter_bloc/flutter_bloc.dart';
import 'restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  RestaurantsCubit() : super(RestaurantsState());
}
