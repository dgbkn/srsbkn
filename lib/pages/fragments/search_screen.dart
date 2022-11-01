import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final controller = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Container(
            color: Theme.of(context).primaryColor,
            child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Card(
                child:  ListTile(
                  leading:  Icon(Icons.search),
                  title:  TextFormField(
                    focusNode: FocusNode(),
                   key: ValueKey(10),
                    
                    controller: controller,
                    decoration:  InputDecoration(
                        hintText: 'Search for...', border: InputBorder.none),
                    // onChanged: onSearchTextChanged,
                  ),
                  trailing:  IconButton(
                    icon:  Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                    },
                  ),
                ),
              ),
            ),
          );
  }
}