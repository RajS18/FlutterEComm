import 'package:ShopApp/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    String x = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(x);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      //we need to make use of custom scroll view....when we have to get more control over what UI animation to generate
      //on scrolling.(Slivers).Here we will convert image into appbar on down scroll. Hence we need to remove AppBar.
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //Now here we need to configure that initially image is displayed as it was earlier without AppBar but on scroll
            //it should smoothly convert to AppBar.
            expandedHeight: 300, //previous height of the Image
            pinned: true, //fixed appBar
            flexibleSpace: FlexibleSpaceBar(//The part this widget that is flexible (convert between Appbar and Image).(title<->background).
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            //takes the list of items that are the part of the sliverList.
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: 200,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 800),//Just to make the list large enough to make it scrollable.
          ])
              //delegate->tells how to render the content of the list
              )
          //Basically as list of Slivers (list is basically your list view as a part of multiple slivers,so in case
          //your list view is a part of multiple scrollable things on a screen which should scroll independently and
          //where you want to have some special tricks when they scroll, then you will use sliver list here.)
        ],
      ),
    );
  }
}
