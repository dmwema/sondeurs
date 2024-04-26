import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sondeurs/data/response/status.dart';
import 'package:sondeurs/model/category/category_model.dart';
import 'package:sondeurs/resource/config/colors.dart';
import 'package:sondeurs/routes/routes_name.dart';
import 'package:sondeurs/view_model/category/category_view_model.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<StatefulWidget> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  CategoryViewModel categoryViewModel = CategoryViewModel();

  Future getData () async {
    categoryViewModel.getCollection();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBg,
      drawer: SafeArea(
        child: Container(
          color: Colors.white,
          child: const Column(
            children: [],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: AppColors.lightBlackBg,
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Toutes les categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              RefreshIndicator(
                onRefresh: getData,
                color: AppColors.primaryColor,
                child: ChangeNotifierProvider<CategoryViewModel>(
                  create: (BuildContext context) => categoryViewModel,
                  child: Consumer<CategoryViewModel>(
                    builder: (context, value, _) {
                      switch (value.categoriesList.status) {
                        case Status.LOADING:
                          return const Padding(
                            padding: EdgeInsets.all(30),
                            child: CupertinoActivityIndicator(
                              radius: 15,
                              color: Colors.white,
                            ),
                          );
                        case Status.ERROR:
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              value.categoriesList.message.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        case Status.COMPLETED:
                          if (value.categoriesList.data!.categories.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/empty.png",
                                    width: 80,
                                    opacity: const AlwaysStoppedAnimation(.1),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: value.categoriesList.data!.categories.length,
                            itemBuilder: (context, index) {
                              CategoryModel current = value.categoriesList.data!.categories[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.lessonDetail,
                                  );
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: current.imagePath == null ? null : DecorationImage(
                                        image: NetworkImage(current.imagePath.toString()),
                                        fit: BoxFit.cover
                                    ),
                                    color: current.imagePath == null ? Colors.white : null,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      current.name.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    // Text(
                                    //   "Une petite description a mettre ici...",
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.w400,
                                    //     color: Colors.white.withOpacity(.5),
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white24,
                                  size: 15,
                                ),
                                shape: Border(
                                  bottom: BorderSide(
                                    color: Colors.white.withOpacity(.1),
                                  ),
                                ),
                                iconColor: Colors.white.withOpacity(.7),
                              );
                            },
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}