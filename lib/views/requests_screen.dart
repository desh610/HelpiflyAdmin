import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_cubit.dart';
import 'package:helpiflyadmin/blocs/app_bloc/app_state.dart';
import 'package:helpiflyadmin/constants/colors.dart';
import 'package:helpiflyadmin/models/request_model.dart';
import 'package:helpiflyadmin/views/request_item_bottomsheet.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

   void _showRequestItemBottomSheet(BuildContext context, RequestModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      builder: (BuildContext context) {
        return RequestItemBottomSheet(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Requests', style: TextStyle(fontSize: 16, color: lightGrayColor),),
          backgroundColor: primaryColor,
          centerTitle: true,
          elevation: 2,
        ),
        body: BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        List<RequestModel> filteredItems = state.requests
            .where((e) => e.status == 'pending')
            .toList();

        if (filteredItems.isNotEmpty) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              RequestModel item = filteredItems[index];
              return GestureDetector(
                onTap: () => _showRequestItemBottomSheet(context, item),
                child: Container(
                  padding: EdgeInsets.only(left: 12),
                  margin: EdgeInsets.all(10),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cardColor,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              item.imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              color: white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.title2,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 140),
              child: Text(
                "No available results",
                style: TextStyle(
                  color: lightGrayColor.withOpacity(0.8),
                  letterSpacing: 1,
                ),
              ),
            ),
          );
        }
      },
    ),
      ),
    );
  }
}

