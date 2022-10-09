import 'package:ShopApp/helpers/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
//NOW HERE INORDER TO SHARE THE PROPERTIES IN PROVIDER WITH OTHER PROVIDER WE NEED TO MAKE USE OF changeNotifierProxyProvider()
//This widget will help in inter provider class communication for provider properties.
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        //Now here the changeNotifierProxyProvider() is a generic type of widget. It will take first argument as the independent
        //widget/object/provider and rest of them as the dependent ones.
        ChangeNotifierProxyProvider<Auth, Products>(
          //now here we need to define the update method that needs to call a function having 3 args. :
          //ctx is used to refer the widget tree defining the state of the widget
          //1st dynamic that is the object of the independent class thats needed to be injected into the dependent obj.
          //2nd dynamic that is needed to store the previous state of the dependent class object.
          update: (ctx, auth, previousProduct) => Products(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items),
          create: null,
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrderList) => Orders(
              auth.token,
              auth.userId,
              previousOrderList == null ? [] : previousOrderList.orders),
          create: null,
        ),
        //In case if you have more than 1 dependencies the we can use changeNotifierProxyProviderN()....here N can be (1-6) dependencies.
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
//This takes a page transition theme where you set up some builders. Now builders is a map and that is a map of 
//different builder functions for different operating systems, so you can even have different transitions for 
//different operating systems, so for Android or iOS. The key simply is TargetPlatform.android for example and
//TargetPlatform.ios.            
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android:CustomPageTransitionBuilder1(),
              TargetPlatform.iOS:CustomPageTransitionBuilder1(),
            })
          ),
          //Now here comes the condition to check whether we need to autolog-in. If the user is authenticated show overview screen.
          //if not authenticated call the function for auto login in a future builder which on connection state == waiting will use a splash screen to display,
          //else if not waiting we will show AuthScreen.

          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, resultOfAutologinSnapShot) =>
                      resultOfAutologinSnapShot.connectionState == ConnectionState.waiting ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
