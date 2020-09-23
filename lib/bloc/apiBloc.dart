import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mvp/apimodel/bloc/apiRepository.dart';
import 'package:mvp/bloc/apiEvent.dart';
import 'package:mvp/bloc/apiState.dart';
import 'package:mvp/models/storeProducts.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiRepository playerRepository;
  ApiBloc({this.playerRepository}) : assert(playerRepository != null), super(null);


  @override
  ApiState get initialState => UninitializedState();

  @override
  Stream<ApiState> mapEventToState(ApiEvent event) async* {
     yield FetchingState();
      List<StoreProduct> players;
      try {
        if (event is Getbestsellers) {
          players = await playerRepository
              .getBSellers();
        }
        if (players.length == 0) {
          yield EmptyState();
        } else {
          yield FetchedState(players: players);
        }
      } catch (_) {
        yield ErrorState();
      }
    }
  }
