import 'package:flutter/material.dart';
import 'package:messanger/features/auth/presentation/pages/profile_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Icon(Icons.person),
        ),
      ),
    );
  }
}
