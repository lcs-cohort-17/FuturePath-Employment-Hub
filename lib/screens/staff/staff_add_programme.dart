// TODO: Replace with final design
// ✅ Uses short programme_id

import 'package:flutter/material.dart';
import '../../models/staff_programme_model.dart';
import '../../services/staff_content_service.dart';
import '../../services/auth_services.dart';
import '../../utils/id_generator.dart';

class StaffAddProgrammeScreen extends StatefulWidget {
  const StaffAddProgrammeScreen({super.key});

  @override
  State<StaffAddProgrammeScreen> createState() => _StaffAddProgrammeScreenState();
}

class _StaffAddProgrammeScreenState extends State<StaffAddProgrammeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _programmeNameCtrl = TextEditingController();
  final _programmeDescriptionCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _levelCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _programmeStatus = 'open';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final auth = AuthService();
      final programme = StaffProgrammeModel(
        programmeId: IdGenerator.generateProgrammeId(),
        programmeName: _programmeNameCtrl.text.trim(),
        programmeDescription: _programmeDescriptionCtrl.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
        capacity: int.tryParse(_capacityCtrl.text.trim()),
        programmeStatus: _programmeStatus,
        requiredSkills: [],
        programmeCategory: _categoryCtrl.text.trim(),
        createdBy: auth.currentUser?.id,
        category: _categoryCtrl.text.trim(),
        level: _levelCtrl.text.trim(),
        skills: [],
        durationMonths: int.tryParse(_durationCtrl.text.trim()),
        enrolledCount: 0,
        createdAt: null,
        updatedAt: null,
      );
      await StaffContentService.createProgramme(programme);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text('Add Programme', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildField('Programme Name', _programmeNameCtrl),
                _buildField('Programme Description', _programmeDescriptionCtrl, maxLines: 3),
                _buildField('Capacity', _capacityCtrl),
                _buildField('Category', _categoryCtrl),
                _buildField('Level', _levelCtrl),
                _buildField('Duration (months)', _durationCtrl),
                _buildDatePicker('Start Date', _startDate, (date) {
                  setState(() => _startDate = date);
                }),
                _buildDatePicker('End Date', _endDate, (date) {
                  setState(() => _endDate = date);
                }),
                DropdownButtonFormField<String>(
                  value: _programmeStatus,
                  dropdownColor: const Color(0xFF2C2E30),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: Colors.white54),
                  ),
                  items: ['open', 'upcoming', 'closed']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _programmeStatus = v!),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE03A2F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Programme', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF2C2E30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? '$label required' : null,
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, Function(DateTime) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030),
          );
          if (picked != null) onSelected(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF2C2E30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : 'Select date',
                style: TextStyle(
                  color: selectedDate != null ? Colors.white : Colors.white54,
                ),
              ),
              const Icon(Icons.calendar_today, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}