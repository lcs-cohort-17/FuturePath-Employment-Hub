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

  Future<List<Programme>> fetchProgrammes() async {
    await _init();
    // Range: sheet name "Programmes", columns A through I (9 columns)
    final range = "'programmesSheet'!A2:I";
    final response = await _sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    final rows = response.values;
    if (rows == null || rows.isEmpty) return [];

    return rows.map((row) {
    return Programme(
      id: int.tryParse(row[0].toString()) ?? 0,
      name: row[1].toString(),
      description: row[2].toString(),
      startDate: DateTime.tryParse(row[3].toString()) ?? DateTime.now(),
      endDate: DateTime.tryParse(row[4].toString()) ?? DateTime.now(),
      capacity: int.tryParse(row[5].toString()) ?? 0,
      status: row[6].toString(),
      skills: row[7].toString().split(',').map((s) => s.trim()).toList(),
      category: row[8].toString(),
    );
    }).toList(); // <-- .toList() converts Iterable to List
  }

  Future<List<Opportunity>> fetchOpportunities() async {
    await _init();
    // Range: sheet name "Programmes", columns A through I (9 columns)
    final range = "'opportunitiesSheet'!A2:J";
    final response = await _sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    final rows = response.values;
    if (rows == null || rows.isEmpty) return [];

    return rows.map((row) {
    return Opportunity(
      id: int.tryParse(row[0].toString()) ?? 0,
      positionTitle: row[1].toString(),
      employerId: int.tryParse(row[2].toString()) ?? 0,
      location: row[3].toString(),
      jobType: row[4].toString(),
      salary: int.tryParse(row[5].toString()) ?? 0,
      closingDate: DateTime.tryParse(row[6].toString()) ?? DateTime.now(),
      skills: row[7].toString().split(',').map((s) => s.trim()).toList(),
      description: row[8].toString(),
      availablePositions: int.tryParse(row[2].toString()) ?? 0,
    );
    }).toList(); // <-- .toList() converts Iterable to List
  }

  Future<List<Employer>> fetchEmployers() async {
    await _init();
    // Range: sheet name "Programmes", columns A through I (9 columns)
    final range = "'employersSheet'!A2:G";
    final response = await _sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    final rows = response.values;
    if (rows == null || rows.isEmpty) return [];

    return rows.map((row) {
    return Employer(
      id: int.tryParse(row[0].toString()) ?? 0,
      companyName: row[1].toString(),
      industry: row[2].toString(),
      location: row[3].toString(),
      contactPerson: row[4].toString(),
      contactNumber: row[5].toString(),
      email: row[6].toString(),
    );
    }).toList(); // <-- .toList() converts Iterable to List
  }
}