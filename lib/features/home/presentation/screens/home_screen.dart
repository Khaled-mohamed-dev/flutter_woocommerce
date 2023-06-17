import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/core/ui_helpers.dart';
import 'package:flutter_woocommerce/core/widgets/base_text.dart';
import 'package:flutter_woocommerce/core/widgets/no_connection.dart';
import 'package:flutter_woocommerce/core/widgets/responsive_icon.dart';
import 'package:flutter_woocommerce/core/widgets/skelton.dart';
import 'package:flutter_woocommerce/features/category/presentation/screens/category_screen.dart';
import 'package:flutter_woocommerce/features/home/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/product/presentation/widgets/products_grid.dart';
import 'package:flutter_woocommerce/features/search/presentation/screens/search_screen.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  'assets/icon.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            horizontalSpaceTiny,
            BaseText('فلوكوميرس', style: Theme.of(context).textTheme.bodySmall!)
          ],
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
              return const HomeScreenLoading();
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
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .fontSize! *
                                (screenWidth(context) / 3.5) /
                                100),
                        decoration: InputDecoration(
                          prefixIcon: ResponsiveIcon(
                            IconlyLight.search,
                            color: kcPrimaryColor,
                          ),
                          suffixIcon: ResponsiveIcon(
                            IconlyLight.filter,
                            color: kcPrimaryColor,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          isDense: true,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .fontSize! *
                                      (screenWidth(context) / 3.5) /
                                      100),
                          filled: true,
                          fillColor: kcSecondaryColor,
                          hintText: '${localization.search}..',
                        ),
                      ),
                      verticalSpaceRegular,
                      Container(
                        height: screenWidthPercentage(context, percentage: .2),
                        constraints: const BoxConstraints(minHeight: 90),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (BuildContext context, int index) {
                            var category = state.categories[index];
                            return category.name != 'Uncategorized'
                                ? GestureDetector(
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
                                      padding: const EdgeInsetsDirectional.only(
                                          end: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kcSecondaryColor,
                                                ),
                                                child: category.image != null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              category.image!,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : const ResponsiveIcon(
                                                        Icons.image),
                                              ),
                                            ),
                                          ),
                                          verticalSpaceTiny,
                                          BaseText(
                                            category.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                      verticalSpaceSmall,
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
              return NoConnectionWidget(reload: () {
                context.read<HomeBloc>().add(LoadHome());
              });
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

class HomeScreenLoading extends StatelessWidget {
  const HomeScreenLoading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Skelton(
              height: screenHeightPercentage(context, percentage: .07),
              width: double.infinity,
            ),
            verticalSpaceRegular,
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: Column(
                      children: const [
                        Skelton(
                          height: 60,
                          width: 60,
                          radius: 100,
                        ),
                        verticalSpaceTiny,
                        Skelton(
                          height: 20,
                          width: 60,
                          radius: 5,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  childAspectRatio: 1 / 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Skelton(
                            height: constraints.maxWidth,
                            width: constraints.maxWidth,
                            radius: 25,
                          ),
                          Skelton(
                            height: 20,
                            width: constraints.maxWidth / 1.3,
                            radius: 5,
                          ),
                          Skelton(
                            height: 20,
                            width: constraints.maxWidth / 1.7,
                            radius: 5,
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
