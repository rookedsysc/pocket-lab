import 'package:flutter/material.dart';

class ModalFit extends StatelessWidget {
  ModalFit({Key? key}) : super(key: key);
  List<String> items = ['Item1', 'item2', 'Item3', 'Item4'];

  @override
  Widget build(BuildContext context) {
    return Material(
      
        child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...List.generate(items.length, (index) {
            return ListTile(
              title: Text(items[index]),
              leading: Icon(Icons.insert_emoticon),
              onTap: () => Navigator.of(context).pop(),
            );
          }),
        ],
      ),
    ));
  }
}