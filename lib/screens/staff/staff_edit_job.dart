// TODO: Replace with final design
// ✅ Uses actual column names from employment_opportunities table

import 'package:flutter/material.dart';
import '../../models/staff_job_model.dart';
import '../../services/staff_content_service.dart';

class StaffEditJobScreen extends StatefulWidget {
  final StaffJobModel job;
  const StaffEditJobScreen({super.key, required this.job});

  @override
  State<StaffEditJobScreen> createState() => _StaffEditJobScreenState();
}

class _StaffEditJobScreenState extends State<StaffEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _positionTitleCtrl;
  late TextEditingController _positionDescriptionCtrl;
  late TextEditingController _positionsCtrl;
  late DateTime? _closingDate;
  late String _opportunityStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _positionTitleCtrl = TextEditingController(text: widget.job.positionTitle);
    _positionDescriptionCtrl = TextEditingController(text: widget.job.positionDescription ?? '');
    _positionsCtrl = TextEditingController(text: widget.job.numberAvailablePositions?.toString() ?? '');
    _closingDate = widget.job.closingDate;
    _opportunityStatus = widget.job.opportunityStatus;
  }

  @override
  void dispose() {
    _positionTitleCtrl.dispose();
    _positionDescriptionCtrl.dispose();
    _positionsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final updatedJob = StaffJobModel(
        opportunityId: widget.job.opportunityId,
        opportunityNumber: widget.job.opportunityNumber,
        positionTitle: _positionTitleCtrl.text.trim(),
        positionDescription: _positionDescriptionCtrl.text.trim(),
        requiredSkills: widget.job.requiredSkills ?? [],
        closingDate: _closingDate,
        opportunityStatus: _opportunityStatus,
        numberAvailablePositions: int.tryParse(_positionsCtrl.text.trim()),
        employerId: widget.job.employerId,
        createdBy: widget.job.createdBy,
        createdAt: widget.job.createdAt,
        updatedAt: DateTime.now(),
      );
      await StaffContentService.updateJob(widget.job.opportunityId, updatedJob);
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
        title: const Text('Edit Job', style: TextStyle(color: Colors.white)),
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
                        : const Text('Update Job', style: TextStyle(color: Colors.white)),
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