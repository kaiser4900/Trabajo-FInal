import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter_app_final/ui/product_screen.dart';
import 'package:flutter_app_final/ui/product_information.dart';
import 'package:flutter_app_final/model/product.dart';
import 'package:flutter_app_final/pages/listview_client.dart';
import 'package:flutter_app_final/pages/listview_sales.dart';

class ListViewProduct extends StatefulWidget {
  @override
  _ListViewProductState createState() => _ListViewProductState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ListViewProductState extends State<ListViewProduct> {

  List<Product> items;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onProductAddedSubscription =
        productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription =
        productReference.onChildChanged.listen(_onProductUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product BD',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Productos'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),

        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[

              new ListTile(
                title:  new Text("Clientes",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25.0,
                  ),),
                trailing: new Icon(Icons.perm_contact_calendar),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => ListViewClient(),
              )),
              ),
              new ListTile(
                title:  new Text("Ventas",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25.0,
                ),),
                trailing: new Icon(Icons.assessment),
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => ListViewSale(),
                )),
              ),
            ],
          ),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 7.0,),
                  Row(
                    children: <Widget>[
                      Expanded(child: ListTile(title: Text('${items[position].name}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 21.0,
                      ),
                      ),
                        subtitle:
                          Text('${items[position].description}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 21.0,
                            ),
                          ),
                        leading: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.orangeAccent,
                              radius: 17.0,
                              child:
                              Text('${position+1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      onTap: () => _navigateToProductInformation(context, items[position]),
                      ),
                      ),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red,),
                          onPressed: () => _deleteProduct(context,items[position],position)),
                      IconButton(
                          icon: Icon(Icons.edit, color: Colors.lightBlueAccent,),
                          onPressed: () => _navigateToProduct(context,items[position])),
                    ],
                  ),
                  Divider(height: 8.0,color: Colors.orangeAccent,thickness: 1.0,),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.orangeAccent,),
          backgroundColor: Colors.white,
          onPressed: () => _createNewProduct(context),
        ),
      ),
    );
  }

  void _onProductAdded (Event event){
    setState(() {
      items.add(new Product.fromSnapShot(event.snapshot));
    });
  }
  void _onProductUpdate (Event event){
    var oldProductValue = items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldProductValue)] = new Product.fromSnapShot(event.snapshot);
    });
  }
  void _deleteProduct(BuildContext context, Product product, int position)async{
    await productReference.child(product.id).remove().then((_){
      setState(() {
        items.removeAt(position);
      });
    });

  }
  void _navigateToProduct(BuildContext context, Product product)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ProductScreen(product)),
    );
  }
  void _navigateToProductInformation(BuildContext context, Product product)async{
    await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ProductInformation(product)),
    );
  }
  void _createNewProduct(BuildContext context) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) =>ProductScreen(Product(null, '', '', '', '', ''))),
    );
  }
}

