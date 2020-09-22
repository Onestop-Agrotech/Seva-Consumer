part of 'apibloc_bloc.dart';

@immutable
abstract class ApiblocEvent {
  const ApiblocEvent();
}

class GetBestSellers extends ApiblocEvent {

  const GetBestSellers();

  @override
  List<Object> get props => [];
}