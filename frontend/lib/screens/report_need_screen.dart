import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ReportNeedScreen extends StatefulWidget {
  final VoidCallback? onNeedCreated;

  const ReportNeedScreen({super.key, this.onNeedCreated});

  @override
  State<ReportNeedScreen> createState() => _ReportNeedScreenState();
}

class _ReportNeedScreenState extends State<ReportNeedScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = 'food';
  double _urgency = 3;
  bool _loading = false;

  static const _categories = ['food', 'medical', 'shelter', 'education'];

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'food': return '🍱 Food';
      case 'medical': return '🏥 Medical';
      case 'shelter': return '🏠 Shelter';
      case 'education': return '📚 Education';
      default: return cat;
    }
  }

  Color _urgencyColor(double u) {
    if (u >= 4) return const Color(0xFFD32F2F);
    if (u >= 3) return const Color(0xFFF9A825);
    return const Color(0xFF388E3C);
  }

Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  try {
    await ApiService().postNeed(
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      category: _category,
      urgency: _urgency.round(),
      description: _descriptionController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Need reported successfully!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear(); // ✅ FIXED

    _formKey.currentState?.reset();

    setState(() {
      _category = 'food';
      _urgency = 3;
    });

    widget.onNeedCreated?.call();

  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _urgencyColor(_urgency);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFEFF),
      appBar: AppBar(
        title: const Text(
          'Report Need',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help coordinate urgent community needs',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              _formField('Title', _titleController, validator: (v) => v?.trim().isEmpty ?? true ? 'Title is required' : null),

              const SizedBox(height: 20),

              // Location
              _formField('Location', _locationController, validator: (v) => v?.trim().isEmpty ?? true ? 'Location is required' : null),

              const SizedBox(height: 20),

              // Category
              _formFieldSection('Category', 
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: _inputDecoration('Select category'),
                  items: _categories.map((c) => DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Text(_categoryLabel(c), style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),

              const SizedBox(height: 20),

              // Urgency
              _formFieldSection('Urgency Level', Slider(
                value: _urgency,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: color,
                inactiveColor: Colors.grey.shade300,
                onChanged: _loading ? null : (v) => setState(() => _urgency = v),
              )),

              const SizedBox(height: 20),

              // Description
              _formField('Description', _descriptionController, maxLines: 4, validator: (v) => v?.trim().isEmpty ?? true ? 'Description required' : null),

              const SizedBox(height: 32),

              // Submit Button
              AnimatedScale(
                scale: _loading ? 1.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _loading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Need',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formField(String label, TextEditingController controller, {int maxLines = 1, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: _inputDecoration(label),
          validator: validator,
        ),
      ],
    );
  }

  Widget _formFieldSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label == 'Title' ? 'Enter need title' :
                label == 'Location' ? 'City or neighborhood' :
                label == 'Description' ? 'What help is needed?' : null,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF1E40AF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
