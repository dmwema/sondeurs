import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sondeurs/resource/config/colors.dart';

class AgentsView extends StatefulWidget {
  const AgentsView({super.key});

  @override
  State<StatefulWidget> createState() => _AgentsViewState();
}

class _AgentsViewState extends State<AgentsView> {
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
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Agents", style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 17
        ),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout, color: Colors.white,)),
        ],
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