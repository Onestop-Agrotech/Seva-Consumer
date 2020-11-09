part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<StoreProduct> searchResults;

  SearchLoaded(this.searchResults);
}

class SearchError extends SearchState {
  final String msg;

  SearchError(this.msg);
}
