import 'package:helpiflyadmin/models/item_model.dart';

class AppState {
  final List<String> categories;
  final List<ItemModel> items;
  final bool isLoading;
  final String? error;
  final int currentTabIndex;
  final List<String> searchTextList;

  AppState({
    required this.categories,
    required this.items,
    required this.isLoading,
    this.error,
    this.currentTabIndex = 0,
    required this.searchTextList
  });

  AppState copyWith({
    List<String>? categories,
    List<ItemModel>? items,
    bool? isLoading,
    String? error,
    int? currentTabIndex,
    List<String>? searchTextList,
  }) {
    return AppState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentTabIndex: currentTabIndex ?? 0,
      searchTextList: searchTextList ?? this.searchTextList,
    );
  }
}
