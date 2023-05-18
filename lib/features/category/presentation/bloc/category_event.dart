import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadData extends CategoryEvent {
  final int categoryID;

  LoadData(this.categoryID);
}

class FetchMoreProducts extends CategoryEvent {
  final int categoryID;

  FetchMoreProducts(this.categoryID);
}
