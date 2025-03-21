import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BiodataService.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Biodataservice? service;
  String? selectedDocId;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = Biodataservice(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: 'Address'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: service?.getBiodata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching data: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No records found'));
                    }

                    final documents = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        final docId = doc.id;
                        final data = doc.data() as Map<String, dynamic>;

                        return ListTile(
                          title: Text(data['name']),
                          subtitle: Text(data['age'].toString()),
                          onTap: () {
                            setState(() {
                              nameController.text = data['name'];
                              ageController.text = data['age'].toString();
                              addressController.text = data['address'];
                              selectedDocId = docId;
                            });
                          },
                          trailing: IconButton(
                            onPressed: () {
                              service?.delete(docId);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final name = nameController.text.trim();
          final age = ageController.text.trim();
          final address = addressController.text.trim();

          if (name.isEmpty || age.isEmpty || address.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All fields must be filled')),
            );
            return;
          }

          if (selectedDocId != null) {
            service?.update(selectedDocId!, {'name': name, 'age': age, 'address': address});
            setState(() => selectedDocId = null);
          } else {
            service?.add({'name': name, 'age': age, 'address': address});
          }

          nameController.clear();
          ageController.clear();
          addressController.clear();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
