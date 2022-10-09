import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ShopApp/providers/orders.dart' as od;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final od.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}
//Since the order item gets the order details ordersScreen which receives it from the orders provoder class.
//And we need to expand it becuase of the details expand button attached we need to decide what needs to be done when
//expand button is pressed. Does it needs to update aanything the provider class / does the expand action act on the state
//locally or centrally where the provider is there. Answer is it acts as local change in this particular screen only.
//hence we make use of Stateful widget.

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20 + 110.0, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd-MMM-yyyy hh:mm').format(widget.order.dateTime),
                //Here the Intl package version is used to manage / manipulate dateTime
              ),
              trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_more)
                    : Icon(Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.order.products.length * 20 + 10.0, 100)
                  : 0,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              //height: min(widget.order.products.length * 20 + 10.0, 100),
              child: ListView(
                  children: widget.order.products
                      .map((e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                e.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('${e.quantity}x \$${e.price}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ))
                            ],
                          ))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }
}
