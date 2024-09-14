import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/helper/helper_functions.dart';
import 'package:helpiflyadmin/models/item_model.dart';
import 'package:helpiflyadmin/models/request_model.dart';
import 'package:helpiflyadmin/widgets/custom_dropdown_by_array.dart';
import 'package:helpiflyadmin/widgets/widgets_exporter.dart';
import 'package:image_picker/image_picker.dart';

class RequestItemBottomSheet extends StatefulWidget {
final RequestModel item;
  const RequestItemBottomSheet({super.key, required this.item});

  @override
  _RequestItemBottomSheetState createState() => _RequestItemBottomSheetState();
}

class _RequestItemBottomSheetState extends State<RequestItemBottomSheet> {
  final TextEditingController _mainTitleController = TextEditingController();
  final TextEditingController _secondaryTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController searchTextController = TextEditingController();
  List<String> filteredSearchTextList = [];
  String _selectedType = 'Product';

  File? _itemImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _itemImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setExistingValues();
     searchTextController.addListener(_filterSearchText);
  }

   void _filterSearchText() {
    final query = searchTextController.text.toLowerCase();
    final allSearchTextList = context.read<AppCubit>().state.categories;
    setState(() {
      filteredSearchTextList = allSearchTextList
          .where((i) => i.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onSuggestionTap(String suggestion) {
     final allCategories = context.read<AppCubit>().state.categories;
    print(suggestion);
    searchTextController.text = suggestion;
    setState(() {
      filteredSearchTextList.clear();
    });
    closeKeyboard(context);
    _dismissSuggestions();
    
  }
 

  void _dismissSuggestions() {
    setState(() {
      filteredSearchTextList.clear();
    });
  }

  setExistingValues(){
    setState(() {
      _mainTitleController.text = widget.item.title;
      _secondaryTitleController.text = widget.item.title2;
      _descriptionController.text = widget.item.description;
      _selectedType = widget.item.type;
      searchTextController.text = widget.item.category;
    });
  }

  @override
  void dispose() {
    _mainTitleController.dispose();
    _secondaryTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      padding: EdgeInsets.all(15.0),
      height: MediaQuery.of(context).size.height -25,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.transparent, size: 20),
              ),
              Text(
                "New item",
                style: TextStyle(
                  fontSize: 16,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_rounded, color: grayColor, size: 24),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                   const SizedBox(height: 20),
                 GestureDetector(
                    onTap: _pickImage,
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            image: _itemImage != null
                                ? DecorationImage(
                                    image: FileImage(_itemImage!),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: widget.item.imageUrl.isNotEmpty
                                        ? NetworkImage(widget.item.imageUrl)
                                        : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Tap to update profile image",
                          style: TextStyle(fontSize: 14, color: grayColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text("Item category", style: TextStyle(color: white, fontWeight: FontWeight.w500),),
                    ],
                  ),
                  CustomSearchBar(
                      controller: searchTextController,
                      onChanged: (text) {
                       
                      },
                    ),
                     if (filteredSearchTextList.isNotEmpty)
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredSearchTextList.length,
                            itemBuilder: (context, index) {
                              final suggestion = filteredSearchTextList[index];
                              return ListTile(
                                title: Text(
                                  suggestion,
                                  style: const TextStyle(color: black),
                                ),
                                onTap: () => _onSuggestionTap(suggestion),
                              );
                            },
                          ),
                        ),
                      ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _mainTitleController,
                    hintText: "Enter main title here",
                    overlineText: "Main title",
                    minLines: 1,
                    maxLines: 1,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _secondaryTitleController,
                    hintText: "Enter secondary title here",
                    overlineText: "Secondary title",
                    minLines: 1,
                    maxLines: 1,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 15),
                    CustomDropdownByArray(
                        items: ['Product', 'Service'],
                        selectedValue:
                            'Product', // Must match exactly one item in the list
                        hintText: 'Select type',
                        overlineText: 'Type',
                        backgroundColor: inCardColor,
                        textColor: white,
                        hintColor: grayColor,
                        overlineTextColor: white,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value??"";
                          });
                        },
                      ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: _descriptionController,
                    hintText: "Enter description here",
                    overlineText: "Description",
                    minLines: 10,
                    maxLines: null,
                    backgroundColor: inCardColor,
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    onTap: () {
                      context.read<AppCubit>().approveItem(
                        existingItem: widget.item,
                        mainTitle: _mainTitleController.text,
                        secondaryTitle: _secondaryTitleController.text,
                        description: _descriptionController.text,
                        itemImage: _itemImage,
                        type: _selectedType,
                        category: searchTextController.text,
                        imageUrl: widget.item.imageUrl,
                        context: context
                      );
                      Navigator.of(context).pop(); // Close the bottom sheet after publishing
                    },
                    buttonText: "Approve",
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
