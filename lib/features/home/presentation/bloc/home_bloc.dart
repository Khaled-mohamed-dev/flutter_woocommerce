import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/category/data/models/category.dart';
import 'package:flutter_woocommerce/features/home/data/models/home_data.dart';
import 'package:flutter_woocommerce/features/home/data/repository/home_repository.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failures.dart';
import '../../../../main.dart';
import 'bloc.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository})
      : super(const HomeState(status: HomeStatus.initial)) {
    on<LoadHome>(
      (event, emit) async {
        if (state.status == HomeStatus.success) return;
        final Either<Failure, HomeData> faliureOrResopnse =
            await homeRepository.loadHomeData();
        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(status: HomeStatus.failure),
            (r) {
              var productsHasReachedMax = r.products.length < 10 ? true : false;
              return state.copyWith(
                products: r.products,
                categories: r.categories,
                productsHasReachedMax: productsHasReachedMax,
                status: HomeStatus.success,
              );
            },
          ),
        );
      },
    );

    on<FetchMoreProducts>(
      (event, emit) async {
        if (state.products.length < 10) {
          emit(state.copyWith(productsHasReachedMax: true));
        }

        if (state.productsHasReachedMax) return;
        logger.d('fetch more products');

        emit(state.copyWith(isLoadingMoreProducts: true));

        int nextPage = ((state.products.length / 10) + 1).toInt();

        final Either<Failure, List<Product>> faliureOrResopnse =
            await homeRepository.fetchProducts(nextPage);

        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(),
            (r) {
              var hasReachedMax = r.length < 10 ? true : false;

              return state.copyWith(
                products: state.products..addAll(r),
                isLoadingMoreProducts: false,
                productsHasReachedMax: hasReachedMax,
              );
            },
          ),
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );

    on<FetchMoreCategories>(
      (event, emit) async {
        if (state.categories.length < 10) {
          emit(state.copyWith(categoriesHasReachedMax: true));
        }
        if (state.categoriesHasReachedMax) return;

        int nextPage = ((state.products.length / 10) + 1).toInt();

        final Either<Failure, List<Category>> faliureOrResopnse =
            await homeRepository.fetchCategories(nextPage);

        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(),
            (r) {
              var hasReachedMax = r.length < 10 ? true : false;
              return state.copyWith(
                categories: state.categories..addAll(r),
                categoriesHasReachedMax: hasReachedMax,
              );
            },
          ),
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );
  }
}
