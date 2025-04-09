import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(e.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return Text('No data');
          }
          final user = snapshot.data!.docs;
          return ListView.builder(
            itemCount: user.length,
            itemBuilder: (context, index) {
              final users = user[index];

              return ListTile(
                title: Text('${users['email']}'),
                subtitle: Text('${users['username']}'),
              );
            },
          );
        },
      ),
      appBar: AppBar(title: Text('Users')),
    );
  }
}
