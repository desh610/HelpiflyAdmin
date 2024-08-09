import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/models/item_model.dart';
import 'package:helpiflyadmin/widgets/custom_button.dart';
import 'package:helpiflyadmin/widgets/new_post_bottomsheet.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

      void _showNewPostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return NewPostBottomSheet();
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: grayColor, borderRadius: BorderRadius.circular(8)),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("All existing products & services", style: TextStyle(color: white, fontWeight: FontWeight.w500),),
                CustomButton(onTap: () => _showNewPostBottomSheet(context), buttonText: "+ Add New", buttonType: ButtonType.Small),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      ItemModel thisItem = state.items[index];
                      return Container(
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
