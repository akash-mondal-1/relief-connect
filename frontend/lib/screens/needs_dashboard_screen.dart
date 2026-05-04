import 'package:flutter/material.dart';
import '../widgets/need_card.dart';
import '../widgets/skeleton_card.dart';
import '../theme.dart';
import '../services/api_service.dart';

class NeedsDashboardScreen extends StatelessWidget {
  const NeedsDashboardScreen({super.key});

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
                    'Needs Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manual feed sorted by urgency (live updates next version)',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _LegendRow(),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // MAIN CONTENT
            Expanded(
              child: FutureBuilder<List<Need>>(
                future: ApiService().getNeeds(),
                builder: (context, snapshot) {

                  // LOADING
if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: 3,
                      itemBuilder: (context, index) => const SkeletonCard(),
                    );
                  }

                  // ERROR
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 8),
                          Text('Error: ${snapshot.error}'),
                        ],
                      ),
                    );
                  }

                  final needs = snapshot.data ?? [];

                  // EMPTY STATE
                  if (needs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'No needs available yet. Add a need to get started.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // ✅ IMPORTANT: RETURN COLUMN
                  return Column(
                    children: [
                      // COUNT HEADER
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Text(
                          '${needs.length} active need${needs.length == 1 ? '' : 's'}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                        ),
                      ),

                      // LIST
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: needs.length,
                          itemBuilder: (context, i) {
                            final need = needs[i];
                            return NeedCard(need: need);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip(const Color(0xFFD32F2F), 'Urgent (4-5)'),
        const SizedBox(width: 8),
        _chip(const Color(0xFFF9A825), 'Moderate (3)'),
        const SizedBox(width: 8),
        _chip(const Color(0xFF388E3C), 'Low (1-2)'),
      ],
    );
  }

  Widget _chip(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}