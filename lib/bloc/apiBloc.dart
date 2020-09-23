import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mvp/apimodel/bloc/apiRepository.dart';
import 'package:mvp/bloc/apiEvent.dart';
import 'package:mvp/bloc/apiState.dart';
import 'package:mvp/models/storeProducts.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiRepository apiRepository;
  ApiBloc({this.apiRepository}) : assert(apiRepository != null), super(null);


  @override
  ApiState get initialState => UninitializedState();

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
     yield FetchingState();
      List<StoreProduct> products;
      try {
        if (event is Getbestsellers) {
          products = await apiRepository
              .getBSellers();
        }
        if (products.length == 0) {
          yield EmptyState();
        } else {
          yield FetchedState(p: products);
        }
      } catch (_) {
        yield ErrorState();
      }
    }
  }
