import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ShopApp/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String id;
  final String productId;
  final int quantity;
  final double price;
  CartItem(this.id, this.productId, this.price, this.quantity, this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (dir) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      //this shows whats the fuction to run on dismissing the tile successfully.
      //NOTE-> "dir" in the argument is the argument that sets or passes the direction of swipe in case of diff. functionalities on diff. direction swipe.
      key: ValueKey(id),
      //key is used to map the CartItem with the product key....because the product_id can be unique key. Watch the video about the keys on Youtube GoogleFlutter classes.
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        //This is all to set the Delete icon in the background. Also you could have add the margin attribute and set
        //it as tile's margin setting to only show red background fully behind the tile.
      ),
      direction: DismissDirection.endToStart,
      //This gives the temporary background Widget to be displayed when the item is to be swipped off
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure'),
            content: Text(' To remove this product from the cart? '),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                  //This will actually close the AlertDialog(remove it from the App. stack) and returns false/true 
                  //depending on the button chosen. This Boolean value is returned to showDialog method that is returned
                  //by it as a Future<Boolean>.
                },
                child: Text('Yes'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
    
                child: Text('No'),
              ),
            ],
          ),
        );
      },
      //This confirms dismiss action. This actually gets direction as the argument and returns "Future<Boolean>"
      //So we chose to return instead a fuction "showDialog" having context(to be passed with the current context) and 
      //builder (to build the Widget to be shown/displayed on action is performed-> AlertDialog(title:,content:,actions:))
      //This fuction builds the Alert Dialog Box which uses user response to return "showDialog" a Future<Boolean>.
      //showDialog actually return a Future.....Lucky us.
      child: Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Padding(
            padding: EdgeInsets.all(1),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: FittedBox(
                    child: Text('\$$price',
                        style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text("Total: \$${(price * quantity)}"),
              trailing: Text("$quantity x"),
            ),
          )),
    );
  }
}
