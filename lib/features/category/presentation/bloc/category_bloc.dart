import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/category/data/repositories/category_repository.dart';
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

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository})
      : super(const CategoryState(status: CategoryStatus.initial)) {
    on<LoadData>(
      (event, emit) async {
        final Either<Failure, List<Product>> faliureOrResopnse =
            await categoryRepository.fetchProductsByCategory(
                event.categoryID, 1);

        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(status: CategoryStatus.failure),
            (r) {
              var hasReachedMax = r.length < 10 ? true : false;
              return state.copyWith(
                status: CategoryStatus.success,
                products: r,
                productsHasReachedMax: hasReachedMax,
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
            await categoryRepository.fetchProductsByCategory(
                event.categoryID, nextPage);

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
  }
}
