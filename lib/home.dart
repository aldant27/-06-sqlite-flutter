import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dbhelper.dart';
import 'entryfrom.dart';
import 'item.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  late List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      // ignore: deprecated_member_use
      itemList = <Item>[];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Item'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: const Text("Tambah Item"),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);
                if (item != null) {
                  // ignore: todo
                  //TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle? textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              itemList[index].name,
              style: textStyle,
            ),
            subtitle: Text(itemList[index].price.toString()),
            trailing: GestureDetector(
              child: const Icon(Icons.delete),
              onTap: () async {
                // ignore: todo
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                //delete contact
                void deleteItem(Item object) async {
                  int result = await dbHelper.delete(object.id);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
            onTap: () async {
              var item = await navigateToEntryForm(context, itemList[index]);
              // ignore: todo
              //TODO 4 Panggil Fungsi untuk Edit data
              //edit contact
              void editItem(Item object) async {
                int result = await dbHelper.update(object);
                if (result > 0) {
                  updateListView();
                }
              }
            },
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      // ignore: todo
      //TODO 1 Select data dari DB
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          count = itemList.length;
        });
      });
    });
  }
}