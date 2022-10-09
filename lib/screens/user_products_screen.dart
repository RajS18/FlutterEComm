import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
    //hence when we open this user_products_screen.dart....we will see only user associated products whereas for products_overview.dart
    //screen we will see all the products.
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    print("Yayy");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(//Till here this is perfect but we have a problem here. when the page first loads
// body is wrapped with future builder. this will call a async method refreshProducts. this will rerun the build method.
//so we first need to comment out the products provider class here in build method becuase it will lead to infinte loop
// another thing that will lead to infinite loop is again future builder will be hit on rerunning the build method.
//Hence we need to make use of consumer class such that only a section of a screen is rebuilt.
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                                    builder:(ctx,productsData,_)=> Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
