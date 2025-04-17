import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/quick_action_model.dart';
import '../bloc/home_dashboard_bloc.dart';
import '../bloc/home_dashboard_event.dart';
import '../../../../core/localization/app_localizations_extension.dart';

/// Widget for customizable quick actions
class CustomizableQuickActions extends StatelessWidget {
  final List<QuickActionModel> quickActions;
  final Function(String actionId) onActionTap;
  final bool isEditable;

  const CustomizableQuickActions({
    super.key,
    required this.quickActions,
    required this.onActionTap,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabledActions =
        quickActions.where((action) => action.enabled).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quick Actions', style: AppTextStyles.headingSmall),
            if (isEditable)
              TextButton.icon(
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        enabledActions.isEmpty
            ? const Center(child: Text('No quick actions enabled'))
            : Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceAround,
              children:
                  enabledActions
                      .map((action) => _buildQuickActionItem(context, action))
                      .toList(),
            ),
      ],
    );
  }

  Widget _buildQuickActionItem(BuildContext context, QuickActionModel action) {
    return InkWell(
      onTap: () => onActionTap(action.id),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(action.icon, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(action.label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // Get the HomeDashboardBloc instance from the current context
    final homeDashboardBloc = context.read<HomeDashboardBloc>();

    showDialog(
      context: context,
      builder:
          (context) => BlocProvider<HomeDashboardBloc>.value(
            value: homeDashboardBloc,
            child: Builder(
              builder:
                  (context) =>
                      _QuickActionsEditDialog(quickActions: quickActions),
            ),
          ),
    );
  }
}

/// Dialog for editing quick actions
class _QuickActionsEditDialog extends StatefulWidget {
  final List<QuickActionModel> quickActions;

  const _QuickActionsEditDialog({required this.quickActions});

  @override
  State<_QuickActionsEditDialog> createState() =>
      _QuickActionsEditDialogState();
}

class _QuickActionsEditDialogState extends State<_QuickActionsEditDialog> {
  late List<QuickActionModel> _actions;

  @override
  void initState() {
    super.initState();
    _actions = List.from(widget.quickActions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.translate('home.editQuickActions')),
      content: SizedBox(
        width: double.maxFinite,
        child: ReorderableListView.builder(
          shrinkWrap: true,
          itemCount: _actions.length,
          itemBuilder: (context, index) {
            final action = _actions[index];
            return ListTile(
              key: Key(action.id),
              leading: Icon(action.icon),
              title: Text(action.label),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: action.enabled,
                    onChanged: (value) {
                      setState(() {
                        _actions[index] = action.copyWith(enabled: value);
                      });
                    },
                  ),
                  const Icon(Icons.drag_handle),
                ],
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = _actions.removeAt(oldIndex);
              _actions.insert(newIndex, item);
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.tr.translate('home.cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<HomeDashboardBloc>().add(
              UpdateQuickActionsEvent(quickActions: _actions),
            );
            Navigator.of(context).pop();
          },
          child: Text(context.tr.translate('home.save')),
        ),
      ],
    );
  }
}
