// import 'package:bloc/bloc.dart';
// import 'package:bloc_concurrency/bloc_concurrency.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_woocommerce/features/favorites/data/repositories/favorites_repository.dart';
// import 'package:flutter_woocommerce/features/product/data/models/product.dart';
// import 'package:stream_transform/stream_transform.dart';

// import '../../../../core/error/failures.dart';
// import 'bloc.dart';

// const throttleDuration = Duration(milliseconds: 100);

// EventTransformer<E> throttleDroppable<E>(Duration duration) {
//   return (events, mapper) {
//     return droppable<E>().call(events.throttle(duration), mapper);
//   };
// }

// class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
//   final FavoritesRepository favoritesRepository;

//   FavoritesBloc({required this.favoritesRepository})
//       : super(FavoritesState(
//             status: FavoritesStatus.initial,
//             favoritesIDs: favoritesRepository.getFavoritesIDs())) {
//     on<LoadFavorites>(
//       (event, emit) async {
//         if (state.status == FavoritesStatus.success) return;
//         final Either<Failure, List<Product>> faliureOrResopnse =
//             await favoritesRepository.fetchFavoriteProducts(1);
//         emit(
//           faliureOrResopnse.fold(
//             (l) => state.copyWith(status: FavoritesStatus.failure),
//             (products) {
//               return state.copyWith(
//                 products: products,
//                 status: FavoritesStatus.success,
//               );
//             },
//           ),
//         );
//       },
//     );

//     on<FetchMoreProducts>(
//       (event, emit) async {
//         if (state.products.length < 10) {
//           emit(state.copyWith(productsHasReachedMax: true));
//         }
//         if (state.productsHasReachedMax) return;

//         emit(state.copyWith(isLoadingMoreProducts: true));

//         int nextPage = ((state.products.length / 10) + 1).toInt();

//         final Either<Failure, List<Product>> faliureOrResopnse =
//             await favoritesRepository.fetchFavoriteProducts(nextPage);

//         emit(
//           faliureOrResopnse.fold(
//             (l) => state.copyWith(),
//             (products) {
//               var hasReachedMax = products.length < 10 ? true : false;
//               return state.copyWith(
//                 products: state.products..addAll(products),
//                 isLoadingMoreProducts: false,
//                 productsHasReachedMax: hasReachedMax,
//               );
//             },
//           ),
//         );
//       },
//       transformer: throttleDroppable(throttleDuration),
//     );

//     on<ChangeFavoriteStatus>((event, emit) {
//       favoritesRepository.changeFavoriteStatus(event.product.id);
//       emit(state.copyWith(favoritesIDs: favoritesRepository.getFavoritesIDs()));
//     });

//     on<DisposeFavorites>((event, emit) {
//       emit(state.copyWith(
//           status: FavoritesStatus.initial, productsHasReachedMax: false));
//     });
//   }
// }
