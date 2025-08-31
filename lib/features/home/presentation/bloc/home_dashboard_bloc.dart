import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/home_preferences_service.dart';
import '../../domain/models/dashboard_card_model.dart';
import '../../domain/models/quick_action_model.dart';
import 'home_dashboard_event.dart';
import 'home_dashboard_state.dart';

/// BLoC for managing the home dashboard state
class HomeDashboardBloc extends Bloc<HomeDashboardEvent, HomeDashboardState> {
  final HomePreferencesService _preferencesService;
  
  /// Register event handlers
  HomeDashboardBloc({
    required HomePreferencesService preferencesService,
  })  : _preferencesService = preferencesService,
        super(HomeDashboardInitial()) {
    on<LoadHomeDashboardEvent>(_onLoadHomeDashboard);
    on<UpdateUserNameEvent>(_onUpdateUserName);
    on<ReorderDashboardCardsEvent>(_onReorderDashboardCards);
    on<ToggleCardVisibilityEvent>(_onToggleCardVisibility);
    on<UpdateDashboardCardsEvent>(_onUpdateDashboardCards);
    on<UpdateQuickActionsEvent>(_onUpdateQuickActions);
  }
  
  /// Handle LoadHomeDashboardEvent
  Future<void> _onLoadHomeDashboard(
    LoadHomeDashboardEvent event,
    Emitter<HomeDashboardState> emit,
  ) async {
    emit(HomeDashboardLoading());
    
    try {
      // Load user name
      final userName = _preferencesService.getUserName();
      
      // Load card order
      final cardOrder = _preferencesService.getCardOrder();
      
      // Load card visibility
      final cardVisibility = _preferencesService.getCardVisibility();
      
      // Load quick actions
      final quickActionsData = _preferencesService.getQuickActions();
      final quickActions = quickActionsData
          .map((data) => QuickActionModel.fromJson(data))
          .toList();
      
      // Create dashboard cards
      final dashboardCards = _createDashboardCards(cardOrder, cardVisibility);
      
      emit(HomeDashboardLoaded(
        userName: userName,
        dashboardCards: dashboardCards,
        quickActions: quickActions,
      ));
    } catch (e) {
      emit(HomeDashboardError(message: e.toString()));
    }
  }
  
  /// Handle UpdateUserNameEvent
  Future<void> _onUpdateUserName(
    UpdateUserNameEvent event,
    Emitter<HomeDashboardState> emit,
  ) async {
    if (state is HomeDashboardLoaded) {
      final currentState = state as HomeDashboardLoaded;
      
      try {
        await _preferencesService.setUserName(event.userName);
        
        emit(HomeDashboardLoaded(
          userName: event.userName,
          dashboardCards: currentState.dashboardCards,
          quickActions: currentState.quickActions,
        ));
      } catch (e) {
        emit(HomeDashboardError(message: e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }
  
  /// Handle ReorderDashboardCardsEvent
  Future<void> _onReorderDashboardCards(
    ReorderDashboardCardsEvent event,
    Emitter<HomeDashboardState> emit,
  ) async {
    if (state is HomeDashboardLoaded) {
      final currentState = state as HomeDashboardLoaded;
      
      try {
        // Update card order
        final newOrder = event.newOrder;
        await _preferencesService.setCardOrder(newOrder);
        
        // Get current visibility
        final cardVisibility = _preferencesService.getCardVisibility();
        
        // Create new dashboard cards
        final dashboardCards = _createDashboardCards(newOrder, cardVisibility);
        
        emit(HomeDashboardLoaded(
          userName: currentState.userName,
          dashboardCards: dashboardCards,
          quickActions: currentState.quickActions,
        ));
      } catch (e) {
        emit(HomeDashboardError(message: e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }
  
  /// Handle ToggleCardVisibilityEvent
  Future<void> _onToggleCardVisibility(
    ToggleCardVisibilityEvent event,
    Emitter<HomeDashboardState> emit,
  ) async {
    if (state is HomeDashboardLoaded) {
      final currentState = state as HomeDashboardLoaded;
      
      try {
        // Get current visibility
        final cardVisibility = _preferencesService.getCardVisibility();
        
        // Update visibility for the specified card
        cardVisibility[event.cardId] = event.isVisible;
        
        // Save updated visibility
        await _preferencesService.setCardVisibility(cardVisibility);
        
        // Get current order
        final cardOrder = _preferencesService.getCardOrder();
        
        // Create new dashboard cards
        final dashboardCards = _createDashboardCards(cardOrder, cardVisibility);
        
        emit(HomeDashboardLoaded(
          userName: currentState.userName,
          dashboardCards: dashboardCards,
          quickActions: currentState.quickActions,
        ));
      } catch (e) {
        emit(HomeDashboardError(message: e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }
  
  /// Handle UpdateDashboardCardsEvent
  Future<void> _onUpdateDashboardCards(
    UpdateDashboardCardsEvent event,
    Emitter<HomeDashboardState> emit,
  ) async {
    if (state is HomeDashboardLoaded) {
      final currentState = state as HomeDashboardLoaded;
      
      try {
        // Create order list and visibility map from updated cards
        final List<String> cardOrder = 
            event.updatedCards.map((card) => card.id).toList();
        final Map<String, bool> cardVisibility = {
          for (var card in event.updatedCards) card.id: card.isVisible,
        };
        
        // Save updated order
        await _preferencesService.setCardOrder(cardOrder);
        
        // Save updated visibility
        await _preferencesService.setCardVisibility(cardVisibility);
        
        // Create new dashboard cards
        final dashboardCards = _createDashboardCards(cardOrder, cardVisibility);
        
        emit(HomeDashboardLoaded(
          userName: currentState.userName,
          dashboardCards: dashboardCards,
          quickActions: currentState.quickActions,
        ));
      } catch (e) {
        emit(HomeDashboardError(message: e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }
  
  /// Handle UpdateQuickActionsEvent
  Future<void> _onUpdateQuickActions(
    UpdateQuickActionsEvent event,
    Emitter<HomeDashboardState> emit,
  ) async {
    if (state is HomeDashboardLoaded) {
      final currentState = state as HomeDashboardLoaded;
      
      try {
        // Convert QuickActionModel list to JSON-compatible format
        final quickActionsData = event.quickActions
            .map((action) => action.toJson())
            .toList();
        
        // Save updated quick actions
        await _preferencesService.setQuickActions(quickActionsData);
        
        emit(HomeDashboardLoaded(
          userName: currentState.userName,
          dashboardCards: currentState.dashboardCards,
          quickActions: event.quickActions,
        ));
      } catch (e) {
        emit(HomeDashboardError(message: e.toString()));
        emit(currentState); // Revert to previous state
      }
    }
  }
  
  /// Create dashboard cards from order and visibility settings
  List<DashboardCardModel> _createDashboardCards(
    List<String> cardOrder,
    Map<String, bool> cardVisibility,
  ) {
    final Map<String, Map<String, dynamic>> cardData = {
      'prayer': {
        'title': 'Prayer Times',
        'icon': Icons.access_time,
      },
      'habits': {
        'title': 'Habits',
        'icon': Icons.check_circle_outline,
      },
      'quran': {
        'title': 'Quran',
        'icon': Icons.menu_book,
      },
      'dhikr': {
        'title': 'Dhikr',
        'icon': Icons.repeat,
      },
      'calendar': {
        'title': 'Islamic Calendar',
        'icon': Icons.calendar_today,
      },
      'qibla': {
        'title': 'Qibla Direction',
        'icon': Icons.explore,
      },
      'hadith': {
        'title': 'Hadith of the Day',
        'icon': Icons.format_quote,
      },
    };
    
    final List<DashboardCardModel> dashboardCards = [];
    
    for (int i = 0; i < cardOrder.length; i++) {
      final String cardId = cardOrder[i];
      final bool isVisible = cardVisibility[cardId] ?? true;
      
      if (cardData.containsKey(cardId)) {
        dashboardCards.add(DashboardCardModel(
          id: cardId,
          title: cardData[cardId]!['title'],
          icon: cardData[cardId]!['icon'],
          isVisible: isVisible,
          order: i,
        ));
      }
    }
    
    return dashboardCards;
  }
}
