import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_woocommerce/core/consts.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/main.dart';
import 'dart:convert';
import '../models/order.dart';
import 'package:http/http.dart' as http;

abstract class OrdersRepository {
  Future<Either<Failure, Unit>> createOrder(Order order);
  Future<Either<Failure, List<Order>>> fetchOrders(int page);
  Future<Either<Failure, Unit>> updateOrder(String id);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final http.Client client;
  final SharedPrefService sharedPrefService;
  OrdersRepositoryImpl({
    required this.client,
    required this.sharedPrefService,
  });

  @override
  Future<Either<Failure, Unit>> createOrder(Order order) async {
    try {
      var response = await client.post(
        Uri.parse('${wcAPI}orders?$wcCred'),
        body: json.encode(order.toJson()),
        headers: {"content-type": "application/json"},
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      logger.wtf(response.body);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Order>>> fetchOrders(int page) async {
    try {
      var response = await client.get(
        Uri.parse(
            '${wcAPI}orders?customer=${sharedPrefService.user?.id}&page=$page&per_page=50&$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var orders = ordersFromJson(response.body);

      logger.wtf(response.body);

      return Right(orders);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOrder(String id) async {
    try {
      var response = await client.put(
        Uri.parse('${wcAPI}orders/$id?$wcCred'),
        body: {"customer_id": sharedPrefService.user!.id},
        headers: {
          "content-type": "application/json",
        },
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      logger.wtf(response.body);

      return const Right(unit);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }
}
