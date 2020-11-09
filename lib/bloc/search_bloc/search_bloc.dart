import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/domain/search_repository.dart';
import 'package:mvp/models/storeProducts.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepositoryImpl _searchRepositoryImpl;
  SearchBloc(this._searchRepositoryImpl) : super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchProduct) {
      try {
        yield SearchLoading();
        final products = await _searchRepositoryImpl.fetch(event.name);
        yield SearchLoaded(products);
      } on UnauthorisedException {
        yield SearchLoading();
        await _searchRepositoryImpl.refreshToken();
        final products = await _searchRepositoryImpl.fetch(event.name);
        yield SearchLoaded(products);
      } catch (err) {
        yield SearchError(err.toString());
      }
    }
  }
}
