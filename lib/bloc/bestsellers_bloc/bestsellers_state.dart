part of 'bestsellers_bloc.dart';

@immutable
abstract class BestsellersState {}

class BestsellersInitial extends BestsellersState {}

class BestSellersInitial extends BestsellersState {}

class BestSellersLoading extends BestsellersState {}

class BestSellersLoaded extends BestsellersState {
  final List<StoreProduct> bestsellers;

  BestSellersLoaded(this.bestsellers);
}

class BestSellersError extends BestsellersState {
  final String msg;

  BestSellersError(this.msg);
}
