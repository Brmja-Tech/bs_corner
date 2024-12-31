class FacilitiesState {}

class FacilitiesAddLoading extends FacilitiesState {}

class FacilitiesAdded extends FacilitiesState {}

class FacilitiesAddFailure extends FacilitiesState {
  final String message;
  FacilitiesAddFailure(this.message);
}
