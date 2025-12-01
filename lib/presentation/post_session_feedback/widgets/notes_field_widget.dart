import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Notes Field Widget
///
/// Displays optional notes text field with character counter
/// for user to provide additional feedback.
class NotesFieldWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const NotesFieldWidget({super.key, required this.onChanged});

  @override
  State<NotesFieldWidget> createState() => _NotesFieldWidgetState();
}

class _NotesFieldWidgetState extends State<NotesFieldWidget> {
  final TextEditingController _controller = TextEditingController();
  final int _maxCharacters = 500;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'edit_note',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Notes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Optional',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Character counter
              Text(
                '${_controller.text.length}/$_maxCharacters',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _controller.text.length > _maxCharacters * 0.9
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Text field
          TextField(
            controller: _controller,
            maxLines: 5,
            maxLength: _maxCharacters,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText:
                  'Share any thoughts about the session, exercises, or how you felt...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              counterText: '',
              contentPadding: EdgeInsets.all(3.w),
            ),
            onChanged: (text) {
              setState(() {});
              widget.onChanged(text);
            },
          ),

          SizedBox(height: 1.h),

          // Quick suggestions
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildSuggestionChip(
                context,
                'Felt great',
                () => _addSuggestion('Felt great during this session! '),
              ),
              _buildSuggestionChip(
                context,
                'Need modification',
                () => _addSuggestion('Some exercises need modification. '),
              ),
              _buildSuggestionChip(
                context,
                'Too challenging',
                () => _addSuggestion('Found this session too challenging. '),
              ),
              _buildSuggestionChip(
                context,
                'Perfect pace',
                () => _addSuggestion('Perfect pace for me. '),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds suggestion chip
  Widget _buildSuggestionChip(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.75.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: theme.colorScheme.primary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Adds suggestion to text field
  void _addSuggestion(String text) {
    final currentText = _controller.text;
    final newText = currentText.isEmpty ? text : '$currentText$text';

    if (newText.length <= _maxCharacters) {
      _controller.text = newText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
      setState(() {});
      widget.onChanged(newText);
    }
  }
}
