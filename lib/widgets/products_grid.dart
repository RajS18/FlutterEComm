import 'package:ShopApp/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
    //locally control what to be displayed 
    ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    
    final productData = Provider.of<Products>(context);
    
    final products = showFavs==true? productData.favoriteItems:productData.items;

    //but for isFavorite functionality...we need each product must have its own provider

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products
          .length, //how many items are present in the grid (counting 1 grid section for each item)
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        //this is similar to the previous method where we have a builder attr. that takes the func. as a value
        //that uses context obj. to instantiate the Provider class. This whereas is a valid approach 
        //when we are using a list of objects as a provider class.

        //NOTE: if we need to instantiate a class over and over to ChangeNotifier class use builder method,
        //whereas if we are using an existing object, we can make use of .value method ("like in product[i] case").
        value: products[i],
        //Also---> ChangeNotifierProvider has an automatic garbage removal method(removes useless memory part/old stored objects that are no longer
        //useful to avoid memory leaks).
        child: ProductItem(),
      
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      //This allows to decide number of cells needed in each row and adjusts that number of column in each row.
      //Alternative was SliverGridDelegateWithFixedExtent()-> helps adjust cell width and automatically adjusts that number of the columns in each row.
    );
  }
}
