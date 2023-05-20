import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_woocommerce/features/favorites/presentation/bloc/bloc.dart';
import 'package:flutter_woocommerce/features/product/data/models/product.dart';
import 'package:iconly/iconly.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    var id = product.id.toString();
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      buildWhen: (previous, current) =>
          previous.favoritesIDs.contains(id) &&
              !current.favoritesIDs.contains(id) ||
          !previous.favoritesIDs.contains(id) &&
              current.favoritesIDs.contains(id),
      builder: (context, state) {
        var isFavorited = state.favoritesIDs.contains(id);
        return IconButton(
          onPressed: () {
            context.read<FavoritesBloc>().add(ChangeFavoriteStatus(product));
          },
          splashRadius: 2,
          padding: const EdgeInsets.all(2),
          visualDensity: VisualDensity.compact,
          icon: Icon(
            isFavorited ? IconlyBold.heart : IconlyLight.heart,
            color: isFavorited ? Colors.red : null,
          ),
        );
      },
    );
  }
}
