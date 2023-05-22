import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/core/consts.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/main.dart';

import '../models/order.dart';

abstract class OrdersRepository {
  Future<Either<Failure, Unit>> createOrder(Order order);
  Future<Either<Failure, List<Order>>> fetchOrders(int page);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final Dio dio;
  final SharedPrefService sharedPrefService;
  OrdersRepositoryImpl({
    required this.dio,
    required this.sharedPrefService,
  });

  var respnseType = ResponseType.plain;

  @override
  Future<Either<Failure, Unit>> createOrder(Order order) async {
    try {
      var response = await dio.post(
        '${wcAPI}orders?$wcCred',
        data: order.toJson(),
        options: Options(
          responseType: respnseType,
        ),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.data);
        return Left(ServerFailure());
      }

      logger.wtf(response.data);

      return const Right(unit);
    } on DioError catch (e) {
      logger.w(e.response);
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Order>>> fetchOrders(int page) async {
    try {
      var response = await dio.get(
        '${wcAPI}orders?customer=${sharedPrefService.user?.id}&page=$page&per_page=50&$wcCred',
        options: Options(
          responseType: respnseType,
        ),
      );

      var orders = ordersFromJson(response.data);

      logger.wtf(response);

      return Right(orders);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }
}

