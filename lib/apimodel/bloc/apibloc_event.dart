part of 'apibloc_bloc.dart';

@immutable
abstract class ApiblocEvent {
  const ApiblocEvent();
}

class GetBestSellers extends ApiblocEvent{
  final String hubid;
  GetBestSellers({@required this.hubid}) : assert(hubid!=null);
}