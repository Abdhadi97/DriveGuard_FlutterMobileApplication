import 'package:flutter/material.dart';
import 'package:drive_guard/components/product_card.dart';
import 'package:drive_guard/models/Product.dart';

import '../details/details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key});

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: demoProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ProductCard(
                product: demoProducts[index],
                onPress: () => Navigator.pushNamed(
                  context,
                  DetailsScreen.routeName,
                  arguments:
                      ProductDetailsArguments(product: demoProducts[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
