import 'package:flutter/material.dart';

class JobApplySuccessScreen extends StatelessWidget {
  const JobApplySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Successfully Applied!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                //Close Button: Returns to the Job Details
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),

                const SizedBox(height: 12),

                //Track Application Button: Navigates using Named Route
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/track_application');
                  },
                  child: const Text('Track Application'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
