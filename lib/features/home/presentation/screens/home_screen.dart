import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/features/category/presentation/screens/category_screen.dart';
import 'package:flutter_woocommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/products_grid.dart';
import 'package:flutter_woocommerce/features/search/presentation/screens/search_screen.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case HomeStatus.success:
              return SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      TextField(
                        cursorColor: kcPrimaryColor,
                        // controller: _searchController,
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            IconlyLight.search,
                            color: kcPrimaryColor,
                          ),
                          suffixIcon: Icon(
                            IconlyLight.filter,
                            color: kcIconColorSelected,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          isDense: true,
                          hintStyle: Theme.of(context).textTheme.titleSmall,
                          filled: true,
                          fillColor: kcSecondaryColor,
                          hintText: 'Search..',
                        ),
                      ),
                      verticalSpaceRegular,
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            var category = state.categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryProductsScreen(
                                            category: category),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kcSecondaryColor,
                                      ),
                                      child: category.image != null
                                          ? Image.network(category.image!)
                                          : const Icon(Icons.image),
                                    ),
                                    verticalSpaceTiny,
                                    Text(
                                      category.name,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ProductsGrid(products: state.products),
                      verticalSpaceSmall,
                      state.isLoadingMoreProducts
                          ? Center(
                              child: CircularProgressIndicator(
                                color: kcPrimaryColor,
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              );
            case HomeStatus.failure:
              return const Center(child: Text('failed to fetch posts'));
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
    if (_isBottom) context.read<HomeBloc>().add(FetchMoreProducts());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SearchScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
