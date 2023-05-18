import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/search/data/models/search_params.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartSearch extends SearchEvent {
  final String query;
  StartSearch(this.query);
}

class SetFilters extends SearchEvent {
  final SearchParmas searchParmas;

  SetFilters(this.searchParmas);
}

class ApplyFilters extends SearchEvent {}

class ClearFilters extends SearchEvent {}

class FetchMoreProducts extends SearchEvent {}
