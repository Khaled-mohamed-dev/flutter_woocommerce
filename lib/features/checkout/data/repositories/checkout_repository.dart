import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_woocommerce/core/error/failures.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/country_data.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/coupon.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_method.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone_location.dart';

import '../../../../core/consts.dart';
import '../../../../main.dart';
import 'package:http/http.dart' as http;

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
  final http.Client client;
  final SharedPrefService prefs;
  CheckoutRepositoryImpl({required this.client, required this.prefs});

  @override
  Future<Either<Failure, List<ShippingMethod>>> fetchShippingMethods(
      int shippingZoneID) async {
    try {
      final stopwatch = Stopwatch()..start();

      var response = await client.get(
        Uri.parse('${wcAPI}shipping/zones/$shippingZoneID/methods?$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = shippingMethodsFromJson(response.body);

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
      var response =
          await client.get(Uri.parse('${wcAPI}shipping/zones?$wcCred'));

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = shippingZoneFromJson(response.body);

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
          client.get(Uri.parse('${wcAPI}data/countries?$wcCred')),
          client.get(Uri.parse('${wcAPI}shipping/zones?$wcCred'))
        ],
      );

      if (countriesAndZonesFutures
          .any(((result) => errorStatusCodes.contains(result.statusCode)))) {
        logger.e(countriesAndZonesFutures
            .firstWhere(
                (result) => errorStatusCodes.contains(result.statusCode))
            .body);
        return Left(ServerFailure());
      }

      var countryDataResponse = countriesAndZonesFutures[0];

      var responseZones = countriesAndZonesFutures[1];

      var zones = shippingZoneFromJson(responseZones.body);

      var countryData = countryDataFromJson(countryDataResponse.body);

      List selectedCountriesCodes = await client
          .get(
            Uri.parse(
                '${wcAPI}settings/general/woocommerce_specific_allowed_countries?$wcCred'),
          )
          .then((value) => jsonDecode(value.body)['value']);

      List<CountryData> selectedCountries = countryData
          .where((element) => selectedCountriesCodes.contains(element.code))
          .toList();

      var futures = zones.map(
        (zone) => client.get(
            Uri.parse('${wcAPI}shipping/zones/${zone.id}/locations?$wcCred')),
      );

      var results = await Future.wait(futures);

      Map<ShippingZone, List<ShippingZoneLocation>> ultimateReturn = {};

      for (var i = 0; i < results.length; i++) {
        ultimateReturn[zones[i]] =
            shippingZoneLocationFromJson(results[i].body).map(
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
      var response = await client.get(
        Uri.parse('${wcAPI}coupons?code=$code&$wcCred'),
      );

      if (errorStatusCodes.contains(response.statusCode)) {
        logger.e(response.body);
        return Left(ServerFailure());
      }

      var result = couponsFromJson(response.body).last;

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
