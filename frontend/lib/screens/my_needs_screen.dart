import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/need_card.dart';
import '../theme.dart';

class MyNeedsScreen extends StatefulWidget {
  const MyNeedsScreen({super.key});

  @override
  State<MyNeedsScreen> createState() => _MyNeedsScreenState();
}

class _MyNeedsScreenState extends State<MyNeedsScreen> {
  List<Need> _needs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMyNeeds();
  }

  Future<void> _loadMyNeeds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final needs = await ApiService().getMyNeeds();
      if (mounted) {
        setState(() {
          _needs = needs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load needs';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteNeed(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Need'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiService().deleteNeed(id);
        _loadMyNeeds();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }

void _showEditDialog(Need need) {
  final titleController = TextEditingController(text: need.title);
  final locationController = TextEditingController(text: need.location);
  final descriptionController = TextEditingController(text: need.description);

  String category = need.category;
  double urgency = need.urgency.toDouble();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setStateDialog) => AlertDialog(
        title: const Text('Edit Need'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: AppTheme.inputDecoration(hintText: 'Title'),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: locationController,
                decoration: AppTheme.inputDecoration(hintText: 'Location'),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: category,
                decoration: AppTheme.inputDecoration(hintText: 'Category'),
                items: ['food', 'medical', 'shelter', 'education']
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.capitalize()),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setStateDialog(() => category = val);
                  }
                },
              ),

              const SizedBox(height: 16),

              Slider(
                value: urgency,
                min: 1,
                max: 5,
                divisions: 4,
                label: urgency.round().toString(),
                onChanged: (val) {
                  setStateDialog(() => urgency = val);
                },
              ),

              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: AppTheme.inputDecoration(hintText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              titleController.dispose();
              locationController.dispose();
              descriptionController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  locationController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fill all required fields')),
                );
                return;
              }

              try {
                await ApiService().updateNeed(
                  need.id,
                  title: titleController.text.trim(),
                  location: locationController.text.trim(),
                  category: category,
                  urgency: urgency.round(),
                  description: descriptionController.text.trim(),
                );

                titleController.dispose();
                locationController.dispose();
                descriptionController.dispose();

                Navigator.pop(context);
                await _loadMyNeeds();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Need updated')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update failed')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            ElevatedButton(
              onPressed: _loadMyNeeds,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_needs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No needs posted yet'),
            Text('Report your first need from the Report tab', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMyNeeds,
      child: ListView.builder(
        itemCount: _needs.length,
        itemBuilder: (context, index) {
          final need = _needs[index];
          return NeedCard(
            need: need,
            onDelete: () => _deleteNeed(need.id),
            onEdit: () => _showEditDialog(need),
          );
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
