import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/resource/components/card/time_sheet/approved_time_sheet_card.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/shift/shift_view_model.dart';

class ApprovedTimeSheetList extends StatefulWidget {
  final ScrollController? scrollController;
  final List timeSheets;
  // final bool loading;

  const ApprovedTimeSheetList({
    Key? key,
    required this.scrollController,
    required this.timeSheets,
  }) : super(key: key);

  @override
  State<ApprovedTimeSheetList> createState() => _ApprovedTimeSheetListState();
}

class _ApprovedTimeSheetListState extends State<ApprovedTimeSheetList> {

  Future<AccountModel> geAccountDate () => AccountViewModel().getAccount();
  AccountModel? account;
  ShiftViewModel shiftViewModel = ShiftViewModel();
  List timeSheets = [];
  bool load = false;

  @override
  Widget build(BuildContext context) {
    bool rangeTitle= true;

    ScrollController? scrollController = widget.scrollController;
    if (!load)  {
      setState(() {
        timeSheets = widget.timeSheets;
        load = true;
      });
    }
    geAccountDate().then((value) {
      if (mounted) {
        setState(() {
          account = value;
        });
      }
    });

    return ListView.builder(
        controller: scrollController,
        itemCount: timeSheets.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (timeSheets[index].runtimeType.toString() == "String") {
            return Column(
              children: [
                const SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.turn_slight_right_outlined, size: 20,),
                      const SizedBox(width: 5,),
                      Text(timeSheets[index] as String, style: const TextStyle(
                          fontWeight: FontWeight.w700
                      ),)
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            );
          } //else {
          return Column(
            children: [
              ApprovedTimeSheetCard(
                timeSheet: timeSheets[index],
              ),
              SizedBox(height: index == timeSheets.length - 1
                  ? 20
                  : 0)
            ],
          );
        }
    );
  }
}