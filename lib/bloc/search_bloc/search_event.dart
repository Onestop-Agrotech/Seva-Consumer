part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchProduct extends SearchEvent {
  final String name;

  SearchProduct({@required this.name}) : assert(name != null);
}
