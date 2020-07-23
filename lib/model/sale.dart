import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Sale {
  String _id;
  String _product;
  String _client;
  String _date;
  String _branch;

  Sale(this._id,this._product,this._client,
      this._date,this._branch);

  Sale.map(dynamic obj){
    this._product = obj['product'];
    this._client = obj['client'];
    this._date = obj['date'];
      this._branch = obj['branch'];
  }

  String get id => _id;
  String get product => _product;
  String get client => _client;
  String get date => _date;
  String get branch => _branch;

  Sale.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _product= snapshot.value['product'];
    _client = snapshot.value['client'];
    _date = snapshot.value['date'];
    _branch = snapshot.value['branch'];
  }
}