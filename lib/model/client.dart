import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Client {
  String _id;
  String _name;
  String _job;
  String _address;

  Client(this._id,this._name,this._job,
      this._address);

  Client.map(dynamic obj){
    this._name = obj['name'];
    this._job = obj['job'];
    this._address = obj['address'];
  }

  String get id => _id;
  String get name => _name;
  String get job => _job;
  String get address => _address;

  Client.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _job = snapshot.value['job'];
    _address = snapshot.value['address'];
  }
}