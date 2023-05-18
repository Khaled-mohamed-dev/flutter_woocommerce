import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/country_data.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/coupon.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_method.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone_location.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';

abstract class CheckoutRepository {
  String? fetchUserAddress();
  Future<Either<Failure, List<ShippingZone>>> fetchShippingZones();
  Future<Either<Failure, List<ShippingMethod>>> fetchShippingMethods(
      int shippingZoneID);
  Future<Either<Failure, List>> fetchShippingZoneLocations();

  Future<Either<Failure, Coupon>> fetchCouponDetails(String code);

  //TODO new suggested feature: support taxes
}

class CheckoutRepositoryImpl implements CheckoutRepository {
  final Dio dio;
  final SharedPrefService prefs;
  CheckoutRepositoryImpl({required this.dio, required this.prefs});

  var options = Options(
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    responseType: ResponseType.plain,
  );

  @override
  Future<Either<Failure, List<ShippingMethod>>> fetchShippingMethods(
      int shippingZoneID) async {
    try {
      final stopwatch = Stopwatch()..start();

      var response = await dio.get(
        '${wcAPI}shipping/zones/$shippingZoneID/methods?$wcCred',
        options: options,
      );

      var result = shippingMethodsFromJson(response.data);

      logger.wtf('function executed in ${stopwatch.elapsed}');

      stopwatch.stop();

      return Right(result);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShippingZone>>> fetchShippingZones() async {
    try {
      var response = await dio.get(
        '${wcAPI}shipping/zones?$wcCred',
        options: options,
      );

      var result = shippingZoneFromJson(response.data);

      return Right(result);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List>> fetchShippingZoneLocations() async {
    try {
      final stopwatch = Stopwatch()..start();

      var countriesAndZonesFutures = await Future.wait(
        [
          dio.get(
            '${wcAPI}data/countries?$wcCred',
            options: options,
          ),
          dio.get(
            '${wcAPI}shipping/zones?$wcCred',
            options: options,
          )
        ],
      );

      var countryDataResponse = countriesAndZonesFutures[0];

      var responseZones = countriesAndZonesFutures[1];

      var zones = shippingZoneFromJson(responseZones.data);

      var countryData = countryDataFromJson(countryDataResponse.data);

      List selectedCountriesCodes = await dio
          .get(
            '${wcAPI}settings/general/woocommerce_specific_allowed_countries?$wcCred',
            options: options,
          )
          .then((value) => jsonDecode(value.data)['value']);

      List<CountryData> selectedCountries = countryData
          .where((element) => selectedCountriesCodes.contains(element.code))
          .toList();

      var futures = zones.map(
        (zone) => dio.get(
          '${wcAPI}shipping/zones/${zone.id}/locations?$wcCred',
          options: options,
        ),
      );

      var results = await Future.wait(futures);

      Map<ShippingZone, List<ShippingZoneLocation>> ultimateReturn = {};

      for (var i = 0; i < results.length; i++) {
        ultimateReturn[zones[i]] =
            shippingZoneLocationFromJson(results[i].data).map(
          (location) {
            var code = location.code;
            if (location.type == 'state') {
              var countryCode = code.split(':')[0];
              var stateCode = code.split(':')[1];

              var name = countryData
                  .firstWhere((element) => element.code == countryCode)
                  .states
                  .firstWhere((element) => element.code == stateCode)
                  .name;

              return location.copyWith(name: name);
            } else if (location.type == 'country') {
              var name = countryData
                  .firstWhere((element) => element.code == code)
                  .name;
              return location.copyWith(name: name);
            } else if (location.type == 'continent') {
              Map continents = {
                'AF': 'Africa',
                'NA': 'North America',
                'OC': 'Oceania',
                'AN': 'Antarctica',
                'AS': 'Asia',
                'EU': 'Europe',
                'SA': 'South America'
              };
              var name = continents[code];
              return location.copyWith(name: name);
            }
            return location.copyWith(name: code);
          },
        ).toList();
      }

      logger.w(ultimateReturn);
      logger.wtf('function executed in ${stopwatch.elapsed}');

      stopwatch.stop();
      return Right([ultimateReturn, selectedCountries]);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Coupon>> fetchCouponDetails(String code) async {
    try {
      var response = await dio.get(
        '${wcAPI}coupons?code=$code&$wcCred',
        options: options,
      );

      var result = couponsFromJson(response.data).last;

      return Right(result);
    } catch (e) {
      logger.e(e);
      return Left(ServerFailure());
    }
  }

  @override
  String? fetchUserAddress() {
    return prefs.user!.shipping?.address1;
  }
}

// old function
// @override
// Future<Either<Failure, List<ShippingZoneLocation>>> fetchShippingZoneLocations(
//     int zonedID) async {
//   try {
//     final stopwatch = Stopwatch()..start();

//     var countryDataResponse = await dio.get(
//       '${wcAPI}data/countries?$wcCred',
//       options: options,
//     );

//     var responseZones = await dio.get(
//       '${wcAPI}shipping/zones?$wcCred',
//       options: options,
//     );

//     var zones = shippingZoneFromJson(responseZones.data);

//     var countryData = countryDataFromJson(countryDataResponse.data);

//     var response = await dio.get(
//       '${wcAPI}shipping/zones/2/locations?$wcCred',
//       options: options,
//     );

//     logger.wtf('response came in ${stopwatch.elapsed}');

//     var result = shippingZoneLocationFromJson(response.data).map(
//       (location) {
//         var code = location.code;
//         if (location.type == 'state') {
//           var countryCode = code.split(':')[0];
//           var stateCode = code.split(':')[1];

//           var name = countryData
//               .firstWhere((element) => element.code == countryCode)
//               .states
//               .firstWhere((element) => element.code == stateCode)
//               .name;

//           return location.copyWith(name: name);
//         } else if (location.type == 'country') {
//           var name =
//               countryData.firstWhere((element) => element.code == code).name;
//           return location.copyWith(name: name);
//         } else if (location.type == 'continent') {
//           Map continents = {
//             'AF': 'Africa',
//             'NA': 'North America',
//             'OC': 'Oceania',
//             'AN': 'Antarctica',
//             'AS': 'Asia',
//             'EU': 'Europe',
//             'SA': 'South America'
//           };
//           var name = continents[code];
//           return location.copyWith(name: name);
//         }
//         return location.copyWith(name: code);
//       },
//     ).toList();

//     logger.d(result);
//     logger.w(ultimateReturn);
//     logger.wtf('function executed in ${stopwatch.elapsed}');

//     stopwatch.stop();
//     return Right([]);
//   } catch (e) {
//     logger.e(e);
//     return Left(ServerFailure());
//   }
// }
