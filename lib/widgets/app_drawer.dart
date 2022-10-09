import 'package:ShopApp/helpers/custom_route.dart';
import 'package:ShopApp/providers/auth.dart';
import 'package:ShopApp/screens/orders_screen.dart';
import 'package:ShopApp/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Everyone! '),
            automaticallyImplyLeading: false,
          ),
          //here automaticallyImplyLeading attribute is attribute of AppBar which is by default true showing that the app bar
          //must contain "<-" (going back arrow) button if Flutter thinks that there is a chance to go backward in the Application Stack(else nothing is present).
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
// //Now make use of More primitive way for navigation and specify our made up Custom Route.
//               Navigator.of(context).pushReplacement(CustomRoute(
//                 builder: (context) => OrdersScreen(),
//              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              //
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
