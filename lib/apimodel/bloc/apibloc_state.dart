part of 'apibloc_bloc.dart';

@immutable
abstract class ApiblocState {}

class ApiblocInitial extends ApiblocState {}

class LoadingState extends ApiblocState {}

class LoadedState extends ApiblocState {
  // final List<StoreProduct> players;
  // PlayerFetchedState({@required this.players});
}
class ErrorState extends ApiblocState {}
