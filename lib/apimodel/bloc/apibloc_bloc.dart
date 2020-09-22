import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/apimodel/bloc/apiRepository.dart';
import 'package:mvp/models/storeProducts.dart';

part 'apibloc_event.dart';
part 'apibloc_state.dart';



class ApiblocBloc extends Bloc<ApiblocEvent, ApiblocState> {
  final ApiRepository repository;

  ApiblocBloc({@required this.repository}) : assert(repository != null), super(null);

  @override
  ApiblocState get initialState => ApiblocInitial();

  @override
  Stream<ApiblocState> mapEventToState(ApiblocEvent event) async* {
    if (event is GetBestSellers) {
      yield LoadingState();
      try {
        final List<StoreProduct> quote = await repository.getBSellers(event.hubid);
        yield LoadedState();
      } catch (_) {
        yield ErrorState();
      }
    }
  }
}
