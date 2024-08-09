import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/models/item_model.dart';
import 'package:helpiflyadmin/widgets/custom_button.dart';
import 'package:helpiflyadmin/widgets/custom_searchbar.dart';
import 'package:helpiflyadmin/widgets/new_item_bottomsheet.dart';
import 'package:helpiflyadmin/widgets/update_item_bottomsheet.dart';

class ItemsScreen extends StatelessWidget {
  ItemsScreen({super.key});

    final TextEditingController searchTextController = TextEditingController();

      void _showNewItemBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return NewItemBottomSheet();
      },
    );
  }
      void _showUpdateItemBottomSheet(BuildContext context, ItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return UpdatetemBottomSheet(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 2,
        title: Text(
          "All items",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: [
            CustomSearchBar(
              key: Key('2'),
              controller: searchTextController,
              onChanged: (text) {
                context.read<AppCubit>().setSearchQuery(text);
              },
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("All existing products & services", style: TextStyle(color: white, fontWeight: FontWeight.w500),),
                CustomButton(onTap: () => _showNewItemBottomSheet(context), buttonText: "+ Add New", buttonType: ButtonType.Small),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                final filteredItems = state.items.where((item) {
                final query = state.searchQuery?.toLowerCase() ?? '';
                return item.title.toLowerCase().contains(query) || item.description.toLowerCase().contains(query);
              }).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      ItemModel thisItem = filteredItems[index];
                      return GestureDetector(
                        onTap: () => _showUpdateItemBottomSheet(context, thisItem),
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: inCardColor,
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                               Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: grayColor,
                                   image: DecorationImage(
                                            image: NetworkImage(
                                                thisItem.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    thisItem.title,
                                    style: TextStyle(color: white),
                                  ),
                                  Text(
                                    thisItem.title2,
                                    style: TextStyle(color: white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
