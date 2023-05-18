import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadOrders extends OrdersEvent {}

class FetchMoreOrders extends OrdersEvent {}
