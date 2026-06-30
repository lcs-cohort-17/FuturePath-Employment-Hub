import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import '../../core/widgets/job_card.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/empty_state_widget.dart';

class StaffManageJobsScreen extends StatefulWidget {
  const StaffManageJobsScreen({super.key});

  @override
  State<StaffManageJobsScreen> createState() => _StaffManageJobsScreenState();
}

class _StaffManageJobsScreenState extends State<StaffManageJobsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Active', 'Draft', 'Closed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the staff company ID (in production, get from auth)
      context.read<JobProvider>().setStaffCompany('comp_001');
      context.read<JobProvider>().loadStaffJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<JobProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.jobs.isEmpty) {
            return const LoadingWidget(message: 'Loading jobs...');
          }

          final filteredJobs = provider.filteredJobs(
            _searchQuery,
            _selectedFilter,
          );

          return RefreshIndicator( // ← WRAP WITH RefreshIndicator
            onRefresh: () => provider.refreshJobs(),
            color: const Color(0xFFE03A2F),
            backgroundColor: const Color(0xFF1A1A1A),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // ← IMPORTANT for refresh
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App bar title
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: Text(
                          'Manage Jobs',
                          style: TextStyle(
                            color: Color(0xFFF0EDE8),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Search bar
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
                                    hintText: 'Search your jobs...',
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

                      // Filter pills
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
                                  onTap: () {
                                    setState(() => _selectedFilter = filter);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFFE03A2F)
                                          : Colors.transparent,
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
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF9E9B96),
                                        fontSize: 11,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // Job count
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${filteredJobs.length} jobs · ${provider.companyName ?? ''}',
                          style: const TextStyle(
                            color: Color(0xFF9E9B96),
                            fontSize: 10,
                          ),
                        ),
                      ),

                      // Job cards
                      if (filteredJobs.isEmpty)
                        const EmptyStateWidget(
                          icon: Icons.work_outline,
                          title: 'No jobs found',
                          subtitle: 'Try adjusting your search or filters',
                        )
                      else
                        for (final job in filteredJobs)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: JobCard(
                              companyInitials: job['companyInitials'] ?? 'AM',
                              companyColor: const Color(0xFF4A9EE8).withValues(alpha: 0.2),
                              title: job['title'] ?? '',
                              company: job['company'] ?? '',
                              tags: List<String>.from(job['skills'] ?? []),
                              meta: job['meta'] ?? '',
                              badgeText: job['status'] ?? 'Active',
                              badgeType: _getBadgeType(job['status'] ?? 'Active'),
                              onEdit: () => _showEditJobBottomSheet(context, job),
                              onDelete: () => _showDeleteConfirmation(context, job['id']),
                            ),
                          ),
                    ],
                  ),
                ),

                // Floating Action Button
                Positioned(
                  bottom: 70,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () => _showAddJobBottomSheet(context),
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

  BadgeType _getBadgeType(String status) {
    switch (status) {
      case 'Active':
        return BadgeType.active;
      case 'Draft':
        return BadgeType.pending;
      case 'Closed':
        return BadgeType.suspended;
      default:
        return BadgeType.active;
    }
  }

  void _showAddJobBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _JobFormBottomSheet(
        onSave: (jobData) {
          context.read<JobProvider>().createJob(jobData);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditJobBottomSheet(BuildContext context, Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _JobFormBottomSheet(
        initialData: job,
        onSave: (jobData) {
          context.read<JobProvider>().updateJob(job['id'], jobData);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Delete Job',
          style: TextStyle(color: Color(0xFFF0EDE8), fontSize: 16),
        ),
        content: const Text(
          'Are you sure you want to delete this job? This action cannot be undone.',
          style: TextStyle(color: Color(0xFF9E9B96), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9E9B96)),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<JobProvider>().deleteJob(jobId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFE03A2F),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Job Form Bottom Sheet Widget (unchanged)
class _JobFormBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final void Function(Map<String, dynamic>) onSave;

  const _JobFormBottomSheet({
    this.initialData,
    required this.onSave,
  });

  @override
  State<_JobFormBottomSheet> createState() => _JobFormBottomSheetState();
}

class _JobFormBottomSheetState extends State<_JobFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _companyController;
  late TextEditingController _locationController;
  late TextEditingController _typeController;
  late TextEditingController _positionsController;
  late TextEditingController _skillsController;
  late TextEditingController _closingDateController;
  late TextEditingController _salaryController;
  late String _selectedStatus;

  final List<String> _statusOptions = ['Active', 'Draft', 'Closed'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _companyController = TextEditingController(text: widget.initialData?['company'] ?? '');
    _locationController = TextEditingController(text: widget.initialData?['location'] ?? '');
    _typeController = TextEditingController(text: widget.initialData?['type'] ?? '');
    _positionsController = TextEditingController(
      text: widget.initialData?['positions']?.toString() ?? '',
    );
    _skillsController = TextEditingController(
      text: (widget.initialData?['skills'] as List?)?.join(', ') ?? '',
    );
    _closingDateController = TextEditingController(
      text: widget.initialData?['closingDate'] ?? '',
    );
    _salaryController = TextEditingController(text: widget.initialData?['salary'] ?? '');
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
              widget.initialData == null ? 'Add New Job' : 'Edit Job',
              style: const TextStyle(
                color: Color(0xFFF0EDE8),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Job Title', _titleController),
            _buildTextField('Company Name', _companyController),
            _buildTextField('Location', _locationController),
            _buildTextField('Job Type (e.g., Full-time)', _typeController),
            _buildTextField('Number of Positions', _positionsController,
                keyboardType: TextInputType.number),
            _buildTextField('Skills (comma separated)', _skillsController),
            _buildTextField('Closing Date', _closingDateController),
            _buildTextField('Salary (e.g., R18k-R25k)', _salaryController),
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
                  widget.initialData == null ? 'Add Job' : 'Update Job',
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
      final jobData = {
        'title': _titleController.text,
        'company': _companyController.text,
        'location': _locationController.text,
        'type': _typeController.text,
        'positions': int.tryParse(_positionsController.text) ?? 0,
        'skills': _skillsController.text.split(',').map((s) => s.trim()).toList(),
        'closingDate': _closingDateController.text,
        'salary': _salaryController.text,
        'status': _selectedStatus,
      };
      widget.onSave(jobData);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _typeController.dispose();
    _positionsController.dispose();
    _skillsController.dispose();
    _closingDateController.dispose();
    _salaryController.dispose();
    super.dispose();
  }
}