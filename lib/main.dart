import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'activity_log/activity_log_service.dart';
import 'activity_log/repositories/supabase_event_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // loads .env file

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example: create the service once and pass it where needed
    final repository = SupabaseEventRepository(Supabase.instance.client);
    final activityLogService = ActivityLogService(repository);

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: activityLogService.getActivityLog(ActivityLogFilter.all),
          builder: (context, snapshot) {
            // ... display the events
            return Container();
          },
        ),
      ),
    );
  }
}