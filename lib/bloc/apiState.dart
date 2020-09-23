import 'package:flutter/material.dart';
import 'package:mvp/models/storeProducts.dart';

abstract class ApiState {}

class UninitializedState extends ApiState {}

class FetchingState extends ApiState {}

class FetchedState extends ApiState {
  final List<StoreProduct> p;
  FetchedState({@required this.p});
}

class ErrorState extends ApiState {}

class EmptyState extends ApiState {}