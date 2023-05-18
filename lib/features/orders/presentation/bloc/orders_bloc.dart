import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_woocommerce/features/orders/data/repositories/orders_repository.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/orders_event.dart';
import 'package:flutter_woocommerce/features/orders/presentation/bloc/orders_state.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/error/failures.dart';
import '../../../../main.dart';
import '../../data/models/order.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;

  OrdersBloc({required this.ordersRepository})
      : super(const OrdersState(status: OrdersStatus.initial)) {
    on<LoadOrders>(
      (event, emit) async {
        final Either<Failure, List<Order>> faliureOrResopnse =
            await ordersRepository.fetchOrders(1);
        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(status: OrdersStatus.failure),
            (r) {
              return state.copyWith(
                orders: r,
                status: OrdersStatus.success,
              );
            },
          ),
        );
      },
    );

    on<FetchMoreOrders>(
      (event, emit) async {
        if (state.orders.length < 10) {
          emit(state.copyWith(hasReachedMax: true));
        }
        if (state.hasReachedMax) return;
        logger.d('fetch more products');

        emit(state.copyWith(isFetchingMore: true));

        int nextPage = ((state.orders.length / 10) + 1).toInt();

        final Either<Failure, List<Order>> faliureOrResopnse =
            await ordersRepository.fetchOrders(nextPage);

        emit(
          faliureOrResopnse.fold(
            (l) => state.copyWith(),
            (r) {
              var hasReachedMax = r.length < 10 ? true : false;

              return state.copyWith(
                orders: state.orders..addAll(r),
                isFetchingMore: false,
                hasReachedMax: hasReachedMax,
              );
            },
          ),
        );
      },
      transformer: throttleDroppable(throttleDuration),
    );
  }
}
