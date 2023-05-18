import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/search/data/models/search_params.dart';
import 'package:flutter_woocommerce/features/search/data/repositories/search_repository.dart';
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

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository})
      : super(const SearchState(status: SearchStatus.initial)) {
    on<StartSearch>((event, emit) async {
      if (event.query.isEmpty) {
        return;
      }

      emit(state.copyWith(status: SearchStatus.loading));

      late SearchParmas searchParams;

      if (state.enableFilters) {
        searchParams = state.searchParmas.copyWith(query: event.query);
      } else {
        searchParams = SearchParmas(query: event.query);
      }

      final Either<Failure, List<Product>> faliureOrResopnse =
          await searchRepository.searchAndFilterProducts(
        searchParmas: searchParams,
        page: 1,
      );

      emit(
        faliureOrResopnse.fold(
          (l) => state.copyWith(status: SearchStatus.failure),
          (r) {
            var hasReachedMax = r.length < 10 ? true : false;

            return state.copyWith(
              status: SearchStatus.success,
              searchParmas: state.searchParmas.copyWith(query: event.query),
              products: r,
              isLoadingMoreProducts: false,
              productsHasReachedMax: hasReachedMax,
            );
          },
        ),
      );
    });

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
            await searchRepository.searchAndFilterProducts(
                searchParmas: state.searchParmas, page: nextPage);

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

    on<SetFilters>((event, emit) {
      emit(state.copyWith(searchParmas: event.searchParmas));
    });

    on<ClearFilters>(
      (event, emit) => emit(
        state.copyWith(
            searchParmas: SearchParmas(query: state.searchParmas.query),
            enableFilters: false),
      ),
    );

    on<ApplyFilters>((event, emit) {
      emit(state.copyWith(enableFilters: true));
    });
  }
}
