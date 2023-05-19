import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/colors.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/products_grid.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wish List'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        bloc: BlocProvider.of(context)..add(LoadFavorites()),
        builder: (context, state) {
          switch (state.status) {
            case FavoritesStatus.initial:
              return Center(
                child: CircularProgressIndicator(color: kcPrimaryColor),
              );
            case FavoritesStatus.success:
              return SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ProductsGrid(products: state.products),
                ),
              );
            case FavoritesStatus.failure:
              return Text(
                'SOME THING WENT WRONG ',
                style: Theme.of(context).textTheme.displayMedium,
              );
          }
        },
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
      context.read<FavoritesBloc>().add(FetchMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
