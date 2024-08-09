import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/models/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class AppCubit extends Cubit<AppState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppCubit()
      : super(AppState(
            categories: [],
            searchTextList: [],
            items: [],
            isLoading: false,
            currentTabIndex: 0, 
            searchQuery: null, categorySearchQuery: null,)) {
    _loadCategories();
    loadItems();
    _loadSearchTextList(); // Load search text list during initialization
  }

  void setCurrentTabIndex(int currentTabIndex) {
    emit(state.copyWith(currentTabIndex: currentTabIndex));
  }

     void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
     void setCategorySearchQuery(String query) {
    emit(state.copyWith(categorySearchQuery: query));
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedCategories = prefs.getString('categories-admin');

      if (cachedCategories != null) {
        List<dynamic> cachedList = jsonDecode(cachedCategories);
        List<String> categories = List<String>.from(cachedList);
        emit(state.copyWith(categories: categories, isLoading: false));
        // Fetch from Firestore to update cache (if needed)
        _fetchCategoriesFromFirestore();
      } else {
        _fetchCategoriesFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load categories: $e'));
    }
  }

  Future<void> _fetchCategoriesFromFirestore() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('categories').doc('categories').get();
      if (doc.exists) {
        List<String> categories = List<String>.from(doc.data()?['data'] ?? []);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('categories-admin', jsonEncode(categories));
        emit(state.copyWith(categories: categories, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: 'Categories document does not exist'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to fetch categories from Firestore: $e'));
    }
  }

  Future<void> loadItems() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedItems = prefs.getString('items-admin');

      if (cachedItems != null) {
        List<dynamic> cachedList = jsonDecode(cachedItems);
        List<ItemModel> items = cachedList.map((item) => ItemModel.fromJson(item)).toList();

         // Sort products and services by credit in descending order
      // products.sort((a, b) => b.credit.compareTo(a.credit));
      
        emit(state.copyWith(items: items, isLoading: false));
        // Fetch from Firestore to update cache (if needed)
        _fetchItemsFromFirestore();
      } else {
        _fetchItemsFromFirestore(); // Fetch from Firestore if not cached
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load items: $e'));
    }
  }

  Future<void> _fetchItemsFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('items').get();

      List<ItemModel> items = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ItemModel.fromJson(data);
      }).toList();


      // services.sort((a, b) => b.credit.compareTo(a.credit));

      // Cache items
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('items-admin', jsonEncode(items.map((item) => item.toJson()).toList()));

      // Emit the updated state with filtered and sorted lists
      emit(state.copyWith(
          items: items,
          isLoading: false));

      // Update search text list after fetching items
      _updateSearchTextList();

    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: 'Failed to fetch items from Firestore: $e'));
    }
  }

 

  Future<void> _loadSearchTextList() async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedSearchTextList = prefs.getString('searchTextList-admin');

      if (cachedSearchTextList != null) {
        List<dynamic> cachedList = jsonDecode(cachedSearchTextList);
        List<String> searchTextList = List<String>.from(cachedList);
        emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
      } else {
        _updateSearchTextList();
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load search text list: $e'));
    }
  }

  Future<void> _updateSearchTextList() async {
    try {
      // Combine categories and item titles
      List<String> searchTextList = [
        ...state.categories,
        ...state.items.map((item) => item.title)
      ];

      // Cache search text list
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('searchTextList-admin', jsonEncode(searchTextList));

      // Emit the updated state
      emit(state.copyWith(searchTextList: searchTextList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to update search text list: $e'));
    }
  }

  Future<String> _uploadItemImage(File profileImage) async {
  try {
    // Load the image
    img.Image? image = img.decodeImage(profileImage.readAsBytesSync());
    
    // Resize the image to a smaller size
    img.Image resizedImage = img.copyResize(image!, width: 100); // Resize to 100 pixels wide (maintaining aspect ratio)
    
    // Compress the image to reduce file size
    List<int> compressedImage = img.encodeJpg(resizedImage, quality: 50); // Adjust quality as needed
    
    // Convert to Uint8List
    Uint8List uint8list = Uint8List.fromList(compressedImage);

    // Upload the compressed image
    String filePath = 'itemImages/2.png';
    await FirebaseStorage.instance.ref(filePath).putData(uint8list);
    String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return downloadUrl;
  } catch (e) {
    throw Exception('Error uploading image: $e');
  }
}

  Future<void> addItem({
  required String mainTitle,
  required String secondaryTitle,
  required String description,
  required String type,
  required String category,
  File? itemImage,
  required BuildContext context,
}) async {
  emit(state.copyWith(isLoading: true));
  try {
    // Upload item image if available
    String? itemImageUrl;
    if (itemImage != null) {
      itemImageUrl = await _uploadItemImage(itemImage);
    }

    // Generate a new document reference and get its ID
    DocumentReference docRef = FirebaseFirestore.instance.collection('items').doc();
    String generatedId = docRef.id;

    // Create ItemModel object with the generated ID
    ItemModel itemModel = ItemModel(
      id: generatedId, // Set the generated ID here
      title: mainTitle,
      title2: secondaryTitle,
      description: description,
      category: category,
      credit: 0,
      imageUrl: itemImageUrl ?? '',
      reviews: [],
      type: type,
    );

    // Save item info to Firestore with the generated ID
    await docRef.set(itemModel.toJson());

    // Save item info to SharedPreferences as a JSON string
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String itemInfoJson = jsonEncode(itemModel.toJson());
    await prefs.setString('items-admin', itemInfoJson);

    emit(state.copyWith(isLoading: false));
    print('Item added successfully!');
    _fetchItemsFromFirestore();
  } on FirebaseAuthException catch (e) {
    emit(state.copyWith(isLoading: false));
    print('FirebaseAuthException: ${e.message}');
  } catch (e) {
    emit(state.copyWith(isLoading: false));
    print('Error: $e');
  }
}

Future<void> updateItem({
  required ItemModel existingItem,
  required String mainTitle,
  required String secondaryTitle,
  required String description,
  required String type,
  required String category,
  File? itemImage,
}) async {
  try {
    emit(state.copyWith(isLoading: true));

    String? itemImageUrl = existingItem.imageUrl;

    // Upload item image if a new file is provided
    if (itemImage != null) {
      itemImageUrl = await _uploadItemImage(itemImage);
    }

    final reviewsAsMapList = existingItem.reviews.map((review) => review.toJson()).toList();

    // Create a map of the updated item data
    final updatedItemInfo = {
      'title': mainTitle,
      'title2': secondaryTitle,
      'description': description,
      'category': category,
      'type': type,
      'credit': existingItem.credit,
      'reviews': reviewsAsMapList,
      'imageUrl': itemImageUrl,
    };

    // Update the Firestore document
    final itemDocRef = FirebaseFirestore.instance
        .collection('items')
        .doc(existingItem.id);
    await itemDocRef.update(updatedItemInfo);

    // Create a new ItemModel with updated information
    final updatedItemInfoModel = ItemModel(
      id: existingItem.id,
      title: mainTitle,
      title2: secondaryTitle,
      description: description,
      type: type,
      category: category,
      credit: existingItem.credit,
      reviews: existingItem.reviews,
      imageUrl: itemImageUrl,
    );

    // Save the updated item info to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String itemInfoJson = jsonEncode(updatedItemInfoModel.toJson());
    await prefs.setString('items-admin', itemInfoJson);

    // Replace the existing item with the updated one in the list
    final updatedItems = state.items.map((item) {
      return item.id == existingItem.id ? updatedItemInfoModel : item;
    }).toList();

    emit(state.copyWith(
      items: updatedItems,
      isLoading: false,
    ));
  } catch (e) {
    emit(state.copyWith(isLoading: false));
    // Handle error appropriately, e.g., show a snackbar or log the error
  }
}



}
