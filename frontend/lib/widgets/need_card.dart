import 'package:flutter/material.dart';
import '../services/api_service.dart';

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

Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'food': return Colors.orange;
    case 'medical': return Colors.red;
    case 'shelter': return Colors.blue;
    case 'clothing': return Colors.purple;
    default: return Colors.grey;
  }
}

String _urgencyLabel(int urgency) {
  if (urgency >= 4) return 'URGENT';
  if (urgency == 3) return 'MODERATE';
  return 'LOW';
}

String _categoryIcon(String category) {
  switch (category) {
    case 'food':
      return '🍱';
    case 'medical':
      return '🏥';
    case 'shelter':
      return '🏠';
    case 'education':
      return '📚';
    default:
      return '📋';
  }
}

class NeedCard extends StatelessWidget {
  final Need need;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NeedCard({
    super.key,
    required this.need,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _urgencyColor(need.urgency);
    final bg = _urgencyBg(need.urgency);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    Text(
                      _categoryIcon(need.category),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getCategoryColor(need.category).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        need.category,
                        style: TextStyle(
                          color: getCategoryColor(need.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 🔴 ACTION BUTTONS (FIX)
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: onEdit,
                      ),

                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: onDelete,
                      ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color),
                      ),
                      child: Text(
                        _urgencyLabel(need.urgency),
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // TITLE
                Text(
                  need.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                // DESCRIPTION
                Text(
                  need.description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF475569),
                  ),
                ),

                const SizedBox(height: 12),

                // FOOTER
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        need.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Row(
                      children: List.generate(
                        5,
                        (i) => Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: i < need.urgency
                                ? color
                                : color.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}