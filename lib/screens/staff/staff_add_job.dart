// TODO: Replace with final design
// ✅ Uses short IDs (fits in varchar(7))

import 'package:flutter/material.dart';
import '../../models/staff_job_model.dart';
import '../../services/staff_content_service.dart';
import '../../services/auth_services.dart';
import '../../utils/id_generator.dart';

class StaffAddJobScreen extends StatefulWidget {
  const StaffAddJobScreen({super.key});

  @override
  State<StaffAddJobScreen> createState() => _StaffAddJobScreenState();
}

class _StaffAddJobScreenState extends State<StaffAddJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _positionTitleCtrl = TextEditingController();
  final _positionDescriptionCtrl = TextEditingController();
  final _positionsCtrl = TextEditingController();
  DateTime? _closingDate;
  String _opportunityStatus = 'open';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final auth = AuthService();
      final job = StaffJobModel(
        opportunityId: IdGenerator.generateOpportunityId(),
        opportunityNumber: IdGenerator.generateOpportunityNumber(),
        positionTitle: _positionTitleCtrl.text.trim(),
        positionDescription: _positionDescriptionCtrl.text.trim(),
        requiredSkills: [],
        closingDate: _closingDate,
        opportunityStatus: _opportunityStatus,
        numberAvailablePositions: int.tryParse(_positionsCtrl.text.trim()),
        employerId: null,
        createdBy: auth.currentUser?.id,
        createdAt: null,
        updatedAt: null,
      );
      await StaffContentService.createJob(job);
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
        title: const Text('Add Job', style: TextStyle(color: Colors.white)),
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
                _buildField('Position Title', _positionTitleCtrl),
                _buildField('Position Description', _positionDescriptionCtrl, maxLines: 3),
                _buildField('Available Positions', _positionsCtrl),
                _buildDatePicker('Closing Date', _closingDate, (date) {
                  setState(() => _closingDate = date);
                }),
                DropdownButtonFormField<String>(
                  value: _opportunityStatus,
                  dropdownColor: const Color(0xFF2C2E30),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: Colors.white54),
                  ),
                  items: ['open', 'closed', 'draft']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _opportunityStatus = v!),
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
                        : const Text('Create Job', style: TextStyle(color: Colors.white)),
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