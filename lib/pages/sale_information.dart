import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_final/model/sale.dart';

class SaleInformation extends StatefulWidget {
  final Sale sale;
  SaleInformation(this.sale);
  @override
  _SaleInformationState createState() => _SaleInformationState();
}

final saleReference = FirebaseDatabase.instance.reference().child('sale');

class _SaleInformationState extends State<SaleInformation> {
  List<Sale> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de la venta'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        height: 400.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text("Producto : ${widget.sale.product}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),

                new Text("Cliente : ${widget.sale.client}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),

                new Text("Día de venta : ${widget.sale.date}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),

                new Text("Sucursal : ${widget.sale.branch}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
