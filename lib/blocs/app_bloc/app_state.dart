import 'package:helpiflyadmin/models/item_model.dart';
import 'package:helpiflyadmin/models/request_model.dart';

class AppState {
  final List<String> categories;
  final List<ItemModel> items;
  final List<RequestModel> requests;
  final bool isLoading;
  final String? error;
  final int currentTabIndex;
  final List<String> searchTextList;
  String? searchQuery;
  String? categorySearchQuery;

  AppState({
    required this.categories,
    required this.items,
    required this.requests,
    required this.isLoading,
    this.error,
    this.currentTabIndex = 0,
    required this.searchTextList,
    this.searchQuery,
    this.categorySearchQuery,
  });

  AppState copyWith({
    List<String>? categories,
    List<ItemModel>? items,
    List<RequestModel>? requests,
    bool? isLoading,
    String? error,
    int? currentTabIndex,
    List<String>? searchTextList,
    String? searchQuery,
    String? categorySearchQuery,
  }) {
    return AppState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex, // Corrected line
      searchTextList: searchTextList ?? this.searchTextList,
      searchQuery: searchQuery ?? this.searchQuery,
      categorySearchQuery: categorySearchQuery ?? this.categorySearchQuery,
    );
  }
}
