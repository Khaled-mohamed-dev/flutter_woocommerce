import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/features/category/data/models/category.dart';
import 'package:flutter_woocommerce/features/category/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/products_grid.dart';
import 'package:flutter_woocommerce/locator.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({Key? key, required this.category})
      : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            locator<CategoryBloc>()..add(LoadData(category.id)),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            switch (state.status) {
              case CategoryStatus.initial:
                return Center(
                  child: CircularProgressIndicator(color: kcPrimaryColor),
                );
              case CategoryStatus.success:
                return PaginatedProductsList(
                  products: state.products,
                  categoryID: category.id,
                );
              case CategoryStatus.failure:
                return Text(
                  'SOME THING WENT WRONG ',
                  style: Theme.of(context).textTheme.displayMedium,
                );
            }
          },
        ),
      ),
    );
  }
}

class PaginatedProductsList extends StatefulWidget {
  const PaginatedProductsList({
    super.key,
    required this.products,
    required this.categoryID,
  });
  final List<Product> products;
  final int categoryID;
  @override
  State<PaginatedProductsList> createState() => _PaginatedProductsListState();
}

class _PaginatedProductsListState extends State<PaginatedProductsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ProductsGrid(products: widget.products),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CategoryBloc>().add(FetchMoreProducts(widget.categoryID));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
