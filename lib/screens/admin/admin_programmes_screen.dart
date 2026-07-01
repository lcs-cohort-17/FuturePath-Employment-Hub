import 'package:flutter/material.dart';

class AdminProgrammesScreen extends StatelessWidget {
  const AdminProgrammesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programmes"),
      ),
      body: const Center(
        child: Text(
          "Admin Programmes",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

//UIUX-017
//Onke/021 starts here
// [UIUX-017] — Place this in the admin programme detail card's onTap
//context.pushNamed(
  //'adminEnrolments',
  //pathParameters: {'programmeId': programme.id},
 // queryParameters: {'programmeName': programme.title},
//);

//Onke/021 Ends Here