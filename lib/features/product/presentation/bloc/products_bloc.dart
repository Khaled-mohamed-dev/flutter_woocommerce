import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/core/widgets/toast.dart';
import 'package:flutter_woocommerce/features/cart/data/models/cart_item.dart';
import 'package:flutter_woocommerce/features/cart/data/repositories/cart_repository.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/data/repositories/products_repository.dart';
import 'package:flutter_woocommerce/features/product/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/product_variation.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;
  final CartRepository cartRepository;
  ProductsBloc({required this.cartRepository, required this.productsRepository})
      : super(const ProductsState(status: ProductsStatus.initial)) {
    on<InitPage>(
      (event, emit) async {
        var product = event.product;

        if (product.type == ProductType.variable) {
          Either<Failure, List<ProductVariation>> faliureOrResopnse =
              await productsRepository.fetchProductVariations(product.id);
          emit(
            faliureOrResopnse.fold(
              (l) {
                return ProductsState(
                  status: ProductsStatus.failure,
                  price: product.price,
                );
              },
              (r) {
                var combinationAndAttributes = getCombinationAndAttributes(r);

                logger.wtf(combinationAndAttributes[0]);

                return ProductsState(
                  status: ProductsStatus.success,
                  // variations: r,
                  combinations: combinationAndAttributes[0],
                  attributes: combinationAndAttributes[1],
                );
              },
            ),
          );
        } else if (product.type == ProductType.grouped) {
          Either<Failure, List<Product>> faliureOrResopnse =
              await productsRepository.fetchGroupedProducts(
                  product.groupedProducts.map((e) => e as int).toList());

          emit(
            faliureOrResopnse.fold(
              (l) {
                return ProductsState(
                  status: ProductsStatus.failure,
                  price: product.price,
                );
              },
              (r) {
                var price = r
                    .map((e) =>
                        e.price.isNotEmpty && e.type != ProductType.variable
                            ? double.parse(e.price)
                            : 0)
                    .reduce((a, b) => a + b)
                    .toStringAsFixed(1);
                return ProductsState(
                  status: ProductsStatus.success,
                  price: price,
                  groupedProducts:
                      r.where((element) => element.price != '').toList(),
                  selectedVariationsGroupedVariableProducts: const {},
                );
              },
            ),
          );
        } else {
          emit(
            ProductsState(
              status: ProductsStatus.success,
              price: product.price,
            ),
          );
        }
      },
    );

    on<HandleButtonClick>(
      (event, emit) {
        var product = event.product;
        switch (product.type) {
          case ProductType.simple:
            cartRepository.addCartItem(
              CartItem(
                productID: product.id,
                quantity: state.qunatity,
                productName: product.name,
                image: product.images.isNotEmpty ? product.images[0] : '',
                productPrice: product.price,
              ),
            );
            break;
          case ProductType.grouped:
            if (state.selectedVariationsGroupedVariableProducts!.length ==
                state.groupedProducts!
                    .where((element) => element.type == ProductType.variable)
                    .length) {
              for (var product in state.groupedProducts!) {
                if (product.type == ProductType.variable) {
                  var variation =
                      (state.selectedVariationsGroupedVariableProducts![
                          product.id] as ProductVariation);
                  String variationTitle = '';
                  for (var attribute in variation.attributes) {
                    variationTitle += '${attribute.name} : ${attribute.option}';
                    if (variation.attributes.last != attribute) {
                      variationTitle += " | ";
                    }
                  }
                  cartRepository.addCartItem(
                    CartItem(
                      productID: product.id,
                      variationID: variation.id,
                      variationTitle: variationTitle,
                      quantity: state.qunatity,
                      productName: product.name,
                      image: variation.image ?? '',
                      productPrice: variation.price,
                    ),
                  );
                } else if (product.type == ProductType.simple) {
                  cartRepository.addCartItem(
                    CartItem(
                      productID: product.id,
                      quantity: state.qunatity,
                      productName: product.name,
                      image: product.images.isNotEmpty ? product.images[0] : '',
                      productPrice: product.price,
                    ),
                  );
                }
              }
            }
            break;
          case ProductType.external:
            launchUrl(Uri.parse(product.externalUrl));
            break;
          case ProductType.variable:
            var variation = state.selectedVariation;

            if (variation != null) {
              String variationTitle = '';
              for (var attribute in variation.attributes) {
                variationTitle += '${attribute.name} : ${attribute.option}';
                if (variation.attributes.last != attribute) {
                  variationTitle += " | ";
                }
              }
              cartRepository.addCartItem(
                CartItem(
                  productID: product.id,
                  variationID: variation.id,
                  variationTitle: variationTitle,
                  quantity: state.qunatity,
                  productName: product.name,
                  image: variation.image ?? '',
                  productPrice: variation.price,
                ),
              );
            }
            break;
        }
        if (product.type != ProductType.external) {
          showToast('Product was added to cart');
        }
      },
    );

    on<SelectCombination>(
      (event, emit) {
        if (event.selectedCombination.any((element) => element == '')) {
          // if its a grouped product
          if (event.variations != null) {
            if (state.selectedVariationsGroupedVariableProducts!
                .containsKey(event.product!.id)) {
              Map newMap =
                  Map.of(state.selectedVariationsGroupedVariableProducts!);
              var price = double.parse(state.price) -
                  (double.parse(newMap[event.product!.id].price) *
                      state.qunatity);
              newMap.remove(event.product!.id);
              emit(
                state.copyWith(
                  selectedVariationsGroupedVariableProducts: newMap,
                  price: price.toString(),
                ),
              );
            }
          } else {
            emit(state.copyWith(
                price: '0', variationImage: null, selectedVariation: null));
          }
        } else {
          if (event.variations != null) {
            List<ProductVariation> variations = event.variations!;
            Map<String, ProductVariation> possibleCombination =
                getCombinationAndAttributes(variations)[0];
            ProductVariation variation =
                possibleCombination[event.selectedCombination.toString()]!;
            if (state.selectedVariationsGroupedVariableProducts == null) {
              emit(
                state.copyWith(selectedVariationsGroupedVariableProducts: {
                  event.product!.id: variation
                }, price: variation.price * state.qunatity),
              );
            } else {
              Map newMap =
                  Map.of(state.selectedVariationsGroupedVariableProducts!);
              newMap[event.product!.id] = variation;
              var price = double.parse(state.price) +
                  (double.parse(variation.price) * state.qunatity);
              emit(
                state.copyWith(
                  selectedVariationsGroupedVariableProducts: newMap,
                  price: price.toStringAsFixed(1),
                ),
              );
            }
          } else {
            ProductVariation variation =
                state.combinations![event.selectedCombination.toString()];
            var image = variation.image;
            emit(state.copyWith(
                price: variation.price,
                variationImage: image,
                selectedVariation: variation));
          }
        }
      },
    );

    on<IncrementQuantity>((event, emit) {
      var quantity = state.qunatity + 1;
      var price = (double.parse(state.price) / state.qunatity) * quantity;
      emit(
        state.copyWith(qunatity: quantity, price: price.toStringAsFixed(1)),
      );
    });

    on<DecrementQuantity>((event, emit) {
      if (state.qunatity > 1) {
        var quantity = state.qunatity - 1;
        var price = (double.parse(state.price) / state.qunatity) * quantity;
        emit(
          state.copyWith(qunatity: quantity, price: price.toStringAsFixed(1)),
        );
      }
    });
  }
}

List getCombinationAndAttributes(List<ProductVariation> variations) {
  // Function brief
  // This Function take a list of ProductVariation and extracts all the attributes that are linked with each and every variation
  // and this creates the [usefullAttributes] and also gets all the [possibleCombinations]
  // then it take the [usefullAttributes] and check if any possibleCombination uses that attribute if not it does not return it (and extra layer of filtering)

  Map<String, ProductVariation> possibleCombinations = {};

  Map<String, List> usefullAttributes = {};

  for (var variation in variations) {
    if (variation.price != '') {
      var combination = [];
      for (var attribute in (variation.attributes)) {
        combination.add(attribute.option);
        var attributeKey = attribute.name;
        if (usefullAttributes[attributeKey] != null) {
          usefullAttributes[attributeKey] =
              (usefullAttributes[attributeKey] as List)
                ..add(
                  attribute.option,
                );
        } else {
          usefullAttributes[attributeKey] = [attribute.option];
        }
        usefullAttributes[attributeKey] =
            (usefullAttributes[attributeKey] as List).toSet().toList();
      }
      possibleCombinations[combination.toString()] = variation;
    }
  }

  var superUsefullAttributes = {};

  usefullAttributes.forEach(
    (key, value) {
      var superUsefullAttribute = value.where((element) {
        return possibleCombinations.keys.any((key) => key.contains(element));
      }).toList();
      superUsefullAttributes[key] = superUsefullAttribute;
    },
  );

  return [possibleCombinations, superUsefullAttributes];
}
