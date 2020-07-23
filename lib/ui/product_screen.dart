import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_final/model/product.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  ProductScreen(this.product);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductScreenState extends State<ProductScreen> {
  List<Product> items;

  // Obteniendo informacion con los controller
  TextEditingController _nameController;
  TextEditingController _codebarController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  TextEditingController _stockController;

  //Vamos a juntar los Controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = new TextEditingController(text: widget.product.name);
    _codebarController = new TextEditingController(text: widget.product.codebar);
    _descriptionController = new TextEditingController(text: widget.product.description);
    _priceController = new TextEditingController(text: widget.product.price);
    _stockController = new TextEditingController(text: widget.product.stock);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Producto'),
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
                  controller: _nameController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                  labelText: 'Nombre'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _descriptionController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.list),
                      labelText: 'Descripción'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _codebarController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.view_week),
                      labelText: 'Código de Barra'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _priceController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.monetization_on),
                      labelText: 'Precio'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                TextField(
                  controller: _stockController,
                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  decoration: InputDecoration(icon: Icon(Icons.shop),
                      labelText: 'Stock'),
                ),
                Padding(padding: EdgeInsets.only(top : 8.0),),
                Divider(),

                FlatButton(onPressed: (){
                  if(widget.product.id != null){
                    productReference.child(widget.product.id).set({
                      'name': _nameController.text,
                      'codebar':_codebarController.text,
                      'description':_descriptionController.text,
                      'price':_priceController.text,
                      'stock':_stockController.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }else{
                    productReference.push().set({
                      'name': _nameController.text,
                      'codebar':_codebarController.text,
                      'description':_descriptionController.text,
                      'price':_priceController.text,
                      'stock':_stockController.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }
                },
                child: (widget.product.id != null) ? Text('Actualizar'):Text('Agregar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
