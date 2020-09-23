import 'package:flutter/material.dart';
import 'package:mvp/models/storeProducts.dart';

abstract class ApiEvent{}

class Getbestsellers extends ApiEvent{
  final StoreProduct nationModel;
  Getbestsellers({@required this.nationModel}) : assert(nationModel!=null);
}
