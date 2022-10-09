import 'package:ShopApp/providers/auth.dart';
import 'package:ShopApp/providers/cart.dart';
import 'package:ShopApp/providers/product.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  //No need of the constructors as we will pull data from provider class "Product" through a listener maintaind over here
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          //Now here we made use of FadeInImage for making an image act as an placeholder untill the imahe is not loaded from the url.
          //placeholder will keep the image we have as a placeholder provided by AssetImage
          //image attribute will provide image url that is being loaded via NetworkImage.
          child: Hero(tag: product.id,child: FadeInImage(placeholder: AssetImage('assets/product-placeholder.png'),image: NetworkImage(product.imageUrl),fit: BoxFit.cover)),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              //Consumer widget is a wrap around widget...here, since the privious listener is
              // not listening to the changes(listen:false), the widget(GestureDetector) will not be updated on change.
              // But since here we wrap Consumer widget for this footer's icon widget, it will get updated [here consumer is a nested listener class]
              // Rest notes are in the copy. "Also Consumer will walk up through widget-tree to find Product Provider class(Product is the generic DT provided to Consumer)"
              builder: (ctx, product, child) => IconButton(
                //ctx provide back channel for communication and product is a variable of dynamic type
                // that holds product class initiated object given by provider when consumer searches for "Product" type provider in Widget Tree.
                // Now child is a sub-widget-tree in Cosumer widget tree that don't needs to be updated.
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleIsFavorite(authToken.token,authToken.userId);
                  print(product.isFavorite);
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id,product.price,product.title);
        //Scaffold.of(context) actually use to establish the connection between nearest Scafflod widget (what screen we are seeing) 
        //avilable from this widge and is used to add alerts/popup()/SnackBars....etc.
                Scaffold.of(context).removeCurrentSnackBar();
                //this removes the SnackBar() if it is already present
                Scaffold.of(context).showSnackBar(
                  //showSnackBar() takes SnackBar() as a widget argument.
                  SnackBar(
                  content: Text("Added an Item to the cart"),
                  //spcify content of the SnackBar();
                  duration: Duration(seconds: 2),
                  //duration takes Duration obj. as a value where "seconds" are needed to specify SnackBar staying time.
                  action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                      //This Specifies the action UI ("Undo" textButton) and logic that is performed if the action is called.
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
