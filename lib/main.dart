import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    routes: {
      'new-contact': (context) => const NewContact(),
    },
  ));
}

class Contact {
  final String id;
  final String name;

  Contact({required this.name}) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();

  factory ContactBook() => _shared;

  //creating a list to contain all the contacts

  int get length => value.length;

  void add({required Contact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  // getting contacts at paeticular index

  Contact? contact({required int atIndex}) =>
      atIndex < value.length ? value[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Book'),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder:(contact, value,  child){
          final contacts = value as List<Contact>;
          return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Dismissible(
              onDismissed: (direction){
                ContactBook().remove(contact: contact);
              },
              key: ValueKey(contact.id),
              child: Material(
                color: Colors.white,
                elevation: 6.0,
                child: ListTile(
                  title: Text(
                    contact.name,
                  ),
                ),
              ),
            );
          },
        );
        }
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('new-contact');
        },
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New contact'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter new Contact here...',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final contact = Contact(
            name: _controller.text,
          );
          ContactBook().add(
            contact: contact,
          );
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.done,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
