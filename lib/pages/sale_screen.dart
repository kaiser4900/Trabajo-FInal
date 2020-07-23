import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_final/model/sale.dart';
import 'package:flutter_app_final/model/client.dart';
import 'package:flutter_app_final/model/product.dart';


class SaleScreen extends StatefulWidget {
  final Sale sale;
  SaleScreen(this.sale);
  @override
  _SaleScreenState createState() => _SaleScreenState();
}

final saleReference = FirebaseDatabase.instance.reference().child('sale');

class _SaleScreenState extends State<SaleScreen> {
  List<Sale> items;
  List<Client> items_Client;
  List<Product> items__Product;

  TextEditingController _productController;
  TextEditingController _clientController;
  TextEditingController _dateController;
  TextEditingController _branchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items__Product = new List();
    items_Client = new List();

    _productController = new TextEditingController(text: widget.sale.product);
    _clientController = new TextEditingController(text: widget.sale.client);
    _dateController = new TextEditingController(text: widget.sale.date);
    _branchController = new TextEditingController(text: widget.sale.branch);
  }

  var lista_product = null;
  var lista_client = null;

  void Cargar(){
    lista_product.addAll(items__Product);
    lista_client.addAll(items_Client);
  }

  @override
  Widget build(BuildContext context) {
    Cargar();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Venta'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _productController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.folder_special),
                      labelText: 'Producto'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _clientController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                      labelText: 'Cliente'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _dateController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.calendar_today),
                      labelText: 'Día de venta'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _branchController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.place),
                      labelText: 'Sucursal'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                FlatButton(onPressed: (){
                  if(widget.sale.id != null){
                    saleReference.child(widget.sale.id).set({
                      'product': _productController.text,
                      'client':_clientController.text,
                      'date':_dateController.text,
                      'branch':_branchController.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }else{
                    saleReference.push().set({
                      'product': _productController.text,
                      'client':_clientController.text,
                      'date':_dateController.text,
                      'branch':_branchController.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }
                },
                    child: (widget.sale.id != null) ? Text('Actualizar'):Text('Agregar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
