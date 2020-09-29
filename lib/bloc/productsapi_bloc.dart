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
    if (event is GetVegetables) {
      try {
        yield ProductsapiLoading();
        final products = await _productRepository.fetchVegetables();
        yield ProductsapiLoaded(products);
      }
      // when recieve a unauthorised token
      on UnauthorisedException {
        yield ProductsapiLoading();
        await _productRepository.refreshToken();
        final products = await _productRepository.fetchVegetables();
        yield ProductsapiLoaded(products);
      } catch (err) {
        yield ProductsapiError(err.toString());
      }
    } else if (event is GetFruits) {
      try {
        yield ProductsapiLoading();
        final products = await _productRepository.fetchFruits();
        yield ProductsapiLoaded(products);
      }
      // when recieve a unauthorised token
      on UnauthorisedException {
        yield ProductsapiLoading();
        await _productRepository.refreshToken();
        final products = await _productRepository.fetchFruits();
        yield ProductsapiLoaded(products);
      } catch (err) {
        print(err);
        yield ProductsapiError(err.toString());
      }
    } else if (event is GetDailyEssentials) {
      try {
        yield ProductsapiLoading();
        final products = await _productRepository.fetchDailyEssentials();
        yield ProductsapiLoaded(products);
      }
      // when recieve a unauthorised token
      on UnauthorisedException {
        yield ProductsapiLoading();
        await _productRepository.refreshToken();
        final products = await _productRepository.fetchDailyEssentials();
        yield ProductsapiLoaded(products);
      } catch (err) {
        print(err);
        yield ProductsapiError(err.toString());
      }
    }
  }
}
