import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/programme_provider.dart';
import '../../core/widgets/programme_card.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state_widget.dart';

class StaffManageProgrammesScreen extends StatefulWidget {
  const StaffManageProgrammesScreen({super.key});

  @override
  State<StaffManageProgrammesScreen> createState() =>
      _StaffManageProgrammesScreenState();
}

class _StaffManageProgrammesScreenState
    extends State<StaffManageProgrammesScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Active', 'Upcoming', 'Closed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the staff company ID (in production, get from auth)
      context.read<ProgrammeProvider>().setStaffCompany('comp_001');
      context.read<ProgrammeProvider>().loadStaffProgrammes();
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return const Color(0xFF4A9EE8);
      case 'security':
        return const Color(0xFFE03A2F);
      case 'marketing':
        return const Color(0xFFF5A623);
      case 'business':
        return const Color(0xFF2ECC8A);
      default:
        return const Color(0xFF9E9B96);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<ProgrammeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.programmes.isEmpty) {
            return const LoadingWidget(message: 'Loading programmes...');
          }

          final filtered = provider.filteredProgrammes(_searchQuery, _selectedFilter);

          return RefreshIndicator( // ← WRAP WITH RefreshIndicator
            onRefresh: () => provider.refreshProgrammes(),
            color: const Color(0xFFE03A2F),
            backgroundColor: const Color(0xFF1A1A1A),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // ← IMPORTANT
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: Text(
                          'Manage Programmes',
                          style: TextStyle(
                            color: Color(0xFFF0EDE8),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF2E2E2E),
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Color(0xFF5C5A57),
                                size: 18,
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    color: Color(0xFFF0EDE8),
                                    fontSize: 12,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Search your programmes...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF5C5A57),
                                      fontSize: 12,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() => _searchQuery = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _filters.map((filter) {
                              final isSelected = filter == _selectedFilter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedFilter = filter),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFE03A2F) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFE03A2F)
                                            : const Color(0xFF2E2E2E),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      filter,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : const Color(0xFF9E9B96),
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${filtered.length} programmes · ${provider.companyName ?? ''}',
                          style: const TextStyle(
                            color: Color(0xFF9E9B96),
                            fontSize: 10,
                          ),
                        ),
                      ),
                      if (filtered.isEmpty)
                        const EmptyStateWidget(
                          icon: Icons.book_outlined,
                          title: 'No programmes found',
                          subtitle: 'Try adjusting your search or filters',
                        )
                      else
                        for (var prog in filtered)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: ProgrammeCard(
                              category: prog['category'] ?? 'General',
                              categoryColor: _getCategoryColor(prog['category'] ?? ''),
                              status: prog['status'] ?? 'Active',
                              title: prog['title'] ?? '',
                              duration: prog['duration'] ?? '3 months',
                              level: prog['level'] ?? 'Beginner',
                              enrolled: prog['enrolled'] ?? 0,
                              capacity: prog['capacity'] ?? 20,
                              startDate: prog['startDate'] ?? 'Starts soon',
                              onEdit: () => _showEditProgrammeBottomSheet(context, prog),
                              onDelete: () => _showDeleteConfirmation(context, prog['id']),
                            ),
                          ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 70,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () => _showAddProgrammeBottomSheet(context),
                    backgroundColor: const Color(0xFFE03A2F),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddProgrammeBottomSheet(BuildContext context) {
    _showProgrammeFormBottomSheet(context, null);
  }

  void _showEditProgrammeBottomSheet(BuildContext context, Map<String, dynamic> programme) {
    _showProgrammeFormBottomSheet(context, programme);
  }

  void _showProgrammeFormBottomSheet(BuildContext context, Map<String, dynamic>? initialData) {
    final bool isEdit = initialData != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ProgrammeFormBottomSheet(
        initialData: initialData,
        onSave: (data) {
          if (isEdit) {
            context.read<ProgrammeProvider>().updateProgramme(initialData!['id'], data);
          } else {
            context.read<ProgrammeProvider>().createProgramme(data);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Delete Programme',
          style: TextStyle(color: Color(0xFFF0EDE8), fontSize: 16),
        ),
        content: const Text(
          'Are you sure you want to delete this programme? This action cannot be undone.',
          style: TextStyle(color: Color(0xFF9E9B96), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9E9B96))),
          ),
          TextButton(
            onPressed: () {
              context.read<ProgrammeProvider>().deleteProgramme(id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFE03A2F)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Programme Form Bottom Sheet (unchanged)
class ProgrammeFormBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic>) onSave;

  const ProgrammeFormBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  State<ProgrammeFormBottomSheet> createState() => _ProgrammeFormBottomSheetState();
}

class _ProgrammeFormBottomSheetState extends State<ProgrammeFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _durationController;
  late TextEditingController _levelController;
  late TextEditingController _capacityController;
  late TextEditingController _startDateController;
  late String _selectedStatus;

  final List<String> _statusOptions = ['Active', 'Upcoming', 'Closed'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _categoryController = TextEditingController(text: widget.initialData?['category'] ?? '');
    _durationController = TextEditingController(text: widget.initialData?['duration'] ?? '');
    _levelController = TextEditingController(text: widget.initialData?['level'] ?? '');
    _capacityController = TextEditingController(
      text: widget.initialData?['capacity']?.toString() ?? '',
    );
    _startDateController = TextEditingController(text: widget.initialData?['startDate'] ?? '');
    _selectedStatus = widget.initialData?['status'] ?? 'Active';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialData == null ? 'Add New Programme' : 'Edit Programme',
              style: const TextStyle(
                color: Color(0xFFF0EDE8),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Programme Title', _titleController),
            _buildTextField('Category (e.g., Technology, Business)', _categoryController),
            _buildTextField('Duration (e.g., 3 months)', _durationController),
            _buildTextField('Level (e.g., Beginner, Intermediate)', _levelController),
            _buildTextField('Capacity', _capacityController, keyboardType: TextInputType.number),
            _buildTextField('Start Date', _startDateController),
            const SizedBox(height: 8),
            const Text(
              'Status',
              style: TextStyle(
                color: Color(0xFF9E9B96),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              dropdownColor: const Color(0xFF1A1A1A),
              style: const TextStyle(color: Color(0xFFF0EDE8), fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
                ),
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE03A2F),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.initialData == null ? 'Add Programme' : 'Update Programme',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9E9B96),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFFF0EDE8), fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'title': _titleController.text,
        'category': _categoryController.text,
        'duration': _durationController.text,
        'level': _levelController.text,
        'capacity': int.tryParse(_capacityController.text) ?? 20,
        'startDate': _startDateController.text,
        'status': _selectedStatus,
      };
      widget.onSave(data);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _levelController.dispose();
    _capacityController.dispose();
    _startDateController.dispose();
    super.dispose();
  }
}