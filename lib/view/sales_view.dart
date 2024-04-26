import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/resource/config/colors.dart';

class SalesView extends StatefulWidget {
  const SalesView({super.key});

  @override
  State<StatefulWidget> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text("Sales", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17
        ),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout, color: Colors.white,)),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(30)
          ),
          width: 60,
          height: 60,
          child: Center(child: Icon(Icons.add, color: Colors.white, size: 30,)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/empty.png", width: 80, opacity: const AlwaysStoppedAnimation(.1),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}