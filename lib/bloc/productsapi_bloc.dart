import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mvp/domain/exceptions.dart';
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
    if (event is GetProducts) {
      try {
        yield ProductsapiLoading();
        final products = await _productRepository.fetchProducts(event.type);
        yield ProductsapiLoaded(products);
      } on UnauthorisedException {
        yield ProductsapiLoading();
        await _productRepository.refreshToken();
        final products = await _productRepository.fetchProducts(event.type);
        yield ProductsapiLoaded(products);
      } catch (err) {
        yield ProductsapiError(err.toString());
      }
    }
  }
}
