import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:person_hive/person.dart';

import 'add_new_person_modal.dart';

class Home extends StatelessWidget {
  Person? user;

  Home({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.wait(
              [Hive.openBox('data'), Hive.openBox<Person>('PersonList')]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.error != null) return const Text('Hive error...');
              return _body(context, user);
            }
            return const Text('Hive opening...');
          },
        ),
      ),
    );
  }
}

Widget _body(context, user) => Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ValueListenableBuilder(
              valueListenable: Hive.box<Person>('PersonList').listenable(),
              builder: (context, persons, _) => PersonListView(persons, user))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddNewPersonModal(user: user);
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );

Widget PersonListView(persons, user) {
  var list = [];
  try {
    if (user != null) {
      print('user => $user');
      print('user.friends => ${user.friends}');
      list = user.friends;
    } else {
      list = persons.values.toList().cast<Person>();
    }
  } catch (e) {
    print('error => $e');
  }

  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      var person = list[index];
      return ListTile(
          title: Text('${person.name}, ${person.age} years old'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home(user: person)),
            );
          });
    },
  );
}
