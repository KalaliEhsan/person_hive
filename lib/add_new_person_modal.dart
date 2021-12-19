import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:person_hive/person.dart';

class AddNewPersonModal extends StatefulWidget {
  Person? user;

  AddNewPersonModal({this.user});

  @override
  State<StatefulWidget> createState() => AddNewPersonModalState();
}

class AddNewPersonModalState extends State<AddNewPersonModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Row(children: [
          Expanded(
            child: TextField(
                decoration: const InputDecoration(label: Text('Name')),
                controller: _nameController),
          )
        ]),
        Row(children: [
          Expanded(
            child: TextField(
                decoration: const InputDecoration(label: Text('Age')),
                controller: _ageController,
                keyboardType: TextInputType.number),
          )
        ]),
        TextButton(
          onPressed: () async {
            var newPerson = Person()
              ..name = _nameController.text
              ..age = _ageController.text;
            if (widget.user != null) {
              // if (widget.user!.friends.isEmpty) {
              //   var newFriends = await Hive.openBox<Person>("PersonList");
              //   newFriends.add(newPerson);
              //   widget.user!.friends = HiveList(newFriends);
              // } else {
                widget.user!.friends.add(newPerson);
                widget.user!.save();
              // }
            } else {
              Hive.box<Person>('PersonList').add(newPerson);
            }
            Navigator.pop(context);
          },
          child: const Text('Register'),
        )
      ],
    );
  }
}
