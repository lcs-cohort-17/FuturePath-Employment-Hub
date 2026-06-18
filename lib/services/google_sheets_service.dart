import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../models/employer.dart';
import '../models/programme.dart';
import '../models/opportunity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSheetsService {
  static final GoogleSheetsService _instance = GoogleSheetsService._internal();
  factory GoogleSheetsService() => _instance;
  GoogleSheetsService._internal();

  late sheets.SheetsApi _sheetsApi;

  static late final String _spreadsheetId = dotenv.env['SPREADSHEET'] ?? '';

  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;

    final jsonString = await rootBundle.loadString('assets/futurepath-sheets.json');
    final credentials = jsonDecode(jsonString) as Map<String, dynamic>;
    final scopes = [sheets.SheetsApi.spreadsheetsScope];

    final authClient = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(credentials),
      scopes
    );

    _sheetsApi = sheets.SheetsApi(authClient);
    _isInitialized = true;
  }
}