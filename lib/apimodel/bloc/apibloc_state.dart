
part of 'apibloc_bloc.dart';

// @immutable
// abstract class ApiblocState {}

// class ApiblocInitial extends ApiblocState {}

// class LoadingState extends ApiblocState {}

// class LoadedState extends ApiblocState {
//   final List<StoreProduct> res;
//   LoadedState({@required this.res});
// }
// class ErrorState extends ApiblocState {}





abstract class ApiblocState {
  const ApiblocState();
}

class ApiInitial extends ApiblocState {
  const ApiInitial();
  @override
  List<Object> get props => [];
}

class ApiLoading extends ApiblocState {
  const ApiLoading();
  @override
  List<Object> get props => [];
}

class ApiLoaded extends ApiblocState {
  final List<StoreProduct> res;
  const ApiLoaded(this.res);
  @override
   get props => [res];
}

class ApiError extends ApiblocState {
  final String message;
  const ApiError(this.message);
  @override
  List<Object> get props => [message];
}
