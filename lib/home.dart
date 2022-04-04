import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql/EntryFrom.dart';
import 'package:sql/dbhelper.dart';

import 'package:sql/item.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
int count = 0;
List<Item> itemList = [];

  get dbHelper => null;

  @override
    Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(
    title: const Text('Daftar Item -Aldant Yafi Abida -2031710009'),
),
    body: Column(
    children: [
  Expanded(
  child: createListView(),
),
  Container(
    alignment: Alignment.bottomCenter,
        child: SizedBox(
        width: double.infinity,
          child: ElevatedButton(
          child: const Text('Tambah Item-Aldant Yafi ABida -2031710009'),
          onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EntryForm()),
      );
    } ,
  ),
  ),
  )
  ],
  ));
}
          ListView createListView() {
        TextStyle? textStyle = Theme.of(context).textTheme.headline5;
        return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) => Card(
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
        onTap: () async {// 3 TODO: delete by id
        },
        ),
        onTap: () async {

},
),
));
}
/* Future<Item> navigateToEntryForm(BuildContext context, Item? item) asyn
c {
var result = await Navigator.push(
context,
MaterialPageRoute(builder: (context) => const EntryForm()),
);
return result;
}*/
void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
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

  //delete contact
  void deleteItem(Item object) async {
    int result = await dbHelper.delete(object.id);
    if (result > 0) {
      updateListView();
    }
  }

  //Edit contact
  void editItem(Item object) async {
    int result = await dbHelper.update(object);
    if (result > 0) {
      updateListView();
    }
  }
}