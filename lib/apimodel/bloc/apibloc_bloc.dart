import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/apimodel/bloc/apiRepository.dart';
import 'package:mvp/models/storeProducts.dart';

part 'apibloc_event.dart';
part 'apibloc_state.dart';

class ApiblocBloc extends Bloc<ApiblocEvent, ApiblocState> {
  final ApiRepository repository;
   ApiblocBloc(this.repository) : super(null);

  @override
  ApiblocState get initialState => ApiInitial();

  @override
  Stream<ApiblocState> mapEventToState(ApiblocEvent event) async* {
          yield ApiLoading();
    if (event is GetBestSellers) {
      try {
        final List<StoreProduct> quote =
            await repository.getBSellers();
        yield ApiLoaded(quote);
      } catch (_) {
        yield ApiError("There is some error");
      }
    }
  }
}
