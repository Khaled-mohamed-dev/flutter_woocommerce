import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/orders/data/models/order.dart';

enum OrdersStatus { initial, success, failure }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.initial,
    this.hasReachedMax = false,
    this.orders = const [],
    this.isFetchingMore = false,
  });

  final OrdersStatus status;
  final List<Order> orders;
  final bool isFetchingMore;
  final bool hasReachedMax;

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return OrdersState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        isFetchingMore: isFetchingMore ?? this.isFetchingMore,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    return '''OrdersState { status: $status, response: }''';
  }

  @override
  List<Object> get props => [
        status,
        orders,
        isFetchingMore,
      ];
}
