import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/domain/product_repository.dart';
import 'package:mvp/models/storeProducts.dart';

part 'productsapi_event.dart';
part 'productsapi_state.dart';

class ProductsapiBloc extends Bloc<ProductsapiEvent, ProductsapiState> {

  final ProductRepositoryImpl _productRepository;

  ProductsapiBloc(this._productRepository) : super(ProductsapiInitial());

  @override
  Stream<ProductsapiState> mapEventToState(
    ProductsapiEvent event,
  ) async* {
    if(event is GetVegetables){
      try{
        yield ProductsapiLoading();
        final products = await _productRepository.fetchVegetables();
        yield ProductsapiLoaded(products);
      } on Exception{
        yield ProductsapiError("Some error occured!");
      }
    }
  }
}
