import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VolunteerMatchScreen extends StatefulWidget {
  const VolunteerMatchScreen({super.key});

  @override
  State<VolunteerMatchScreen> createState() => _VolunteerMatchScreenState();
}

class _VolunteerMatchScreenState extends State<VolunteerMatchScreen> {
  final _skillsController = TextEditingController();
  List<MatchResult> _results = [];
  bool _loading = false;
  bool _searched = false;
  String? _error;


  Future<void> _search() async {
    final skills = _skillsController.text.trim();
    if (skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter at least one skill')),
      );
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _searched = false;
    });
    try {
      final results = await ApiService().matchNeeds(skills);
      if (!mounted) return;
      setState(() {
        _results = results;
        _searched = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _skillsController.dispose();
    super.dispose();
  }

  Color _urgencyColor(int urgency) {
    if (urgency >= 4) return const Color(0xFFD32F2F);
    if (urgency == 3) return const Color(0xFFF9A825);
    return const Color(0xFF388E3C);
  }

  Color _urgencyBg(int urgency) {
    if (urgency >= 4) return const Color(0xFFFFEBEE);
    if (urgency == 3) return const Color(0xFFFFFDE7);
    return const Color(0xFFE8F5E9);
  }

  String _categoryIcon(String category) {
    switch (category) {
      case 'food': return '🍱';
      case 'medical': return '🏥';
      case 'shelter': return '🏠';
      case 'education': return '📚';
      default: return '📋';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Volunteer Match',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C63FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Deterministic matching by category, keywords, urgency',
                        style: TextStyle(color: Color(0xFF6C63FF), fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _skillsController,
                          decoration: InputDecoration(
hintText: 'e.g. food distribution, first aid (manual MVP match)',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.auto_awesome, color: Color(0xFF6C63FF)),
                          ),
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          onPressed: _loading ? null : _search,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Match', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              ),
            if (_searched && _results.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 56, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No matches found. Try different skills.', style: TextStyle(color: Colors.grey, fontSize: 15)),
                      SizedBox(height: 4),
                      Text('Matched based on category and keyword similarity', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            if (_results.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF6C63FF)),
                    const SizedBox(width: 6),
                    Text(
                      '${_results.length} match${_results.length == 1 ? '' : 'es'} found',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6C63FF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _results.length,
                  itemBuilder: (context, i) {
                    final r = _results[i];
                    final color = _urgencyColor(r.need.urgency);
                    final bg = _urgencyBg(r.need.urgency);
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: color.withOpacity(0.4), width: 1.5),
                      ),
                      child: Container(
                        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(_categoryIcon(r.need.category), style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    r.need.category.toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.auto_awesome, size: 11, color: Color(0xFF6C63FF)),
                                      const SizedBox(width: 3),
                                      Text('#${i + 1}', style: const TextStyle(fontSize: 11, color: Color(0xFF6C63FF), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(r.need.description, style: const TextStyle(fontSize: 14, height: 1.4, color: Color(0xFF1A1A2E))),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(r.need.location, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF).withOpacity(0.07),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.psychology_outlined, size: 16, color: Color(0xFF6C63FF)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text("Score: ${r.score ?? 'N/A'}"),
                                              backgroundColor: Colors.blue.withOpacity(0.1),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                r.reason,
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (!_searched && _error == null && !_loading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 72, color: const Color(0xFF6C63FF).withOpacity(0.3)),
                      const SizedBox(height: 16),
                      const Text(
                        'Describe your skills and run\na deterministic match.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
