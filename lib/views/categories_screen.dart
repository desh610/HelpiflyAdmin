import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/models/item_model.dart';
import 'package:helpiflyadmin/widgets/custom_searchbar.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});

  final TextEditingController categorySearchTextController = TextEditingController();

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
          "All Categories",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(
              key: Key("1"),
              controller: categorySearchTextController,
              onChanged: (text) {
                context.read<AppCubit>().setCategorySearchQuery(text);
              },
            ),
            SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                   final filteredCategories = state.categories.where((category) {
                  final query = state.categorySearchQuery?.toLowerCase() ?? '';
                  return category.toLowerCase().contains(query);
                }).toList();
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      String thisCategory = filteredCategories[index];
                      return Container(
                        // height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: inCardColor,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          thisCategory,
                          style: TextStyle(color: white),
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
