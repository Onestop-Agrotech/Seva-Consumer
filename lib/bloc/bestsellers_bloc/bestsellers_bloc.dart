import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/domain/bestsellers_repository.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/models/storeProducts.dart';
part 'bestsellers_event.dart';
part 'bestsellers_state.dart';

class BestsellersBloc extends Bloc<BestsellersEvent, BestsellersState> {
  final BestSellerRepositoryImpl _bestSellerRepository;
  BestsellersBloc(this._bestSellerRepository) : super(BestsellersInitial());

  @override
  Stream<BestsellersState> mapEventToState(
    BestsellersEvent event,
  ) async* {
    if (event is GetBestSellers) {
      yield* _loadBestSellers(_bestSellerRepository.fetchBestSellers);
    }
  }

  Stream<BestsellersState> _loadBestSellers(func) async* {
    try {
      yield BestSellersLoading();
      final products = await func();
      yield BestSellersLoaded(products);
    } on UnauthorisedException {
      yield* _exceptionHandler(func);
    } catch (err) {
      print(err);
      yield BestSellersError(err.toString());
    }
  }

  Stream<BestsellersState> _exceptionHandler(func) async* {
    yield BestSellersLoading();
    await _bestSellerRepository.refreshToken();
    final products = await func();
    yield BestSellersLoaded(products);
  }
}
