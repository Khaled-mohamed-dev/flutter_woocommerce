import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/checkout/data/models/shipping_zone.dart';
import 'package:flutter_woocommerce/features/checkout/data/repositories/checkout_repository.dart';
import 'package:flutter_woocommerce/features/checkout/presentation/bloc/bloc.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository checkoutRepository;
  final SharedPrefService sharedPrefService;

  CheckoutBloc(
      {required this.sharedPrefService, required this.checkoutRepository})
      : super(const CheckoutState()) {
    on<FetchShippingZones>((event, emit) {});

    on<LoadCheckout>(
      (event, emit) async {
        emit(
          state.copyWith(
            shippingAddress: sharedPrefService.user?.shipping?.address1 ?? '',
          ),
        );
        var failureOrResponse =
            await checkoutRepository.fetchShippingZoneLocations();
        failureOrResponse.fold(
          (l) => null,
          (r) => emit(
            state.copyWith(
              status: CheckoutStatus.success,
              shippingZones: r[0],
              countries: r[1],
              selectedCountry: r[1].first,
            ),
          ),
        );
      },
    );

    on<SelectCountry>(
      (event, emit) {
        emit(state.copyWith(selectedCountry: event.country));
      },
    );

    on<SelectState>(
      (event, emit) async {
        ShippingZone? selectedZone;

        for (var element in state.shippingZones!.entries) {
          var firstOrNull = element.value.map((e) => e.code).firstWhereOrNull(
              (element) => element.contains(event.state.code));
          if (firstOrNull != null) {
            selectedZone = element.key;
            break;
          }
        }

        if (selectedZone == null) {
          for (var element in state.shippingZones!.entries) {
            var firstOrNull = element.value.map((e) => e.code).firstWhereOrNull(
                (element) => element == state.selectedCountry!.code);
            if (firstOrNull != null) {
              selectedZone = element.key;
              break;
            }
          }
        }

        if (selectedZone != null) {
          emit(state.copyWith(isFetchingShippingMethods: true));
          await checkoutRepository.fetchShippingMethods(selectedZone.id).then(
                (value) => value.fold(
                  (l) => null,
                  (r) => emit(
                    state.copyWith(
                      isFetchingShippingMethods: false,
                      shippingMethods: r,
                      noShippingMethods: false,
                      selectedState: event.state,
                    ),
                  ),
                ),
              );
        } else {
          emit(
            state.copyWith(selectedState: event.state, noShippingMethods: true),
          );
        }
      },
    );

    on<SelectShippingMethod>(
      (event, emit) => emit(
        state.copyWith(selectedShippingMethod: event.method),
      ),
    );

    on<ChangeAddress>(
      (event, emit) {
        var user = sharedPrefService.user!;
        sharedPrefService.user = user.copyWith(
          shipping: user.shipping!.copyWith(address1: event.address),
        );
        emit(state.copyWith(shippingAddress: event.address));
      },
    );
  }
}
