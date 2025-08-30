import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/home/domain/models/dashboard_card_model.dart';
import 'package:muslim_habbit/features/home/presentation/bloc/home_dashboard_bloc.dart';
import 'package:muslim_habbit/features/home/presentation/bloc/home_dashboard_event.dart';
import 'package:muslim_habbit/features/home/presentation/bloc/home_dashboard_state.dart';

class AdvancedDashboardCustomization extends StatefulWidget {
  const AdvancedDashboardCustomization({super.key});

  @override
  State<AdvancedDashboardCustomization> createState() =>
      _AdvancedDashboardCustomizationState();
}

class _AdvancedDashboardCustomizationState
    extends State<AdvancedDashboardCustomization> {
  late List<DashboardCardModel> _dashboardCards;

  @override
  void initState() {
    super.initState();
    _dashboardCards = [];
    _loadDashboardCards();
  }

  void _loadDashboardCards() {
    context.read<HomeDashboardBloc>().add(const LoadHomeDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeDashboardBloc, HomeDashboardState>(
      listener: (context, state) {
        if (state is HomeDashboardLoaded) {
          setState(() {
            _dashboardCards = List.from(state.dashboardCards);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customize Dashboard'),
          actions: [
            TextButton(
              onPressed: _saveCustomization,
              child: const Text('Save'),
            ),
          ],
        ),
        body: _buildCustomizationContent(),
      ),
    );
  }

  Widget _buildCustomizationContent() {
    if (_dashboardCards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ReorderableListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (int index = 0; index < _dashboardCards.length; index++)
          _buildCardItem(_dashboardCards[index], index),
      ],
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final DashboardCardModel item = _dashboardCards.removeAt(oldIndex);
          _dashboardCards.insert(newIndex, item);

          // Update order for all items
          for (int i = 0; i < _dashboardCards.length; i++) {
            _dashboardCards[i] = _dashboardCards[i].copyWith(order: i);
          }
        });
      },
    );
  }

  Widget _buildCardItem(DashboardCardModel card, int index) {
    return Card(
      key: ValueKey(card.id),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(card.icon),
        title: Text(card.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visibility toggle
            Switch(
              value: card.isVisible,
              onChanged: (value) {
                setState(() {
                  _dashboardCards[index] =
                      card.copyWith(isVisible: value);
                });
              },
            ),
            // Drag handle
            const Icon(Icons.drag_handle),
          ],
        ),
      ),
    );
  }

  void _saveCustomization() {
    // Send the updated cards to the bloc
    context.read<HomeDashboardBloc>().add(
          UpdateDashboardCardsEvent(
            updatedCards: _dashboardCards,
          ),
        );

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard customization saved'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back
    Navigator.of(context).pop();
  }
}