import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/resource/components/card/shift/apply_card.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/shift/shift_view_model.dart';

class ApplyList extends StatefulWidget {
  final ScrollController? scrollController;
  final List shifts;
  final bool hasMore;
  final bool loading;
  bool? owner = false;
  bool? home = false;
  bool? padding = true;
  bool? hideSearch = false;
  String range;
  String type;
  String type2;
  String search;
  String search2;
  DateTime? rangeStartDate;
  DateTime? rangeEndDate;
  DateTime? rangeStartDate2;
  DateTime? rangeEndDate2;

  ApplyList({
    Key? key,
    required this.scrollController,
    required this.shifts,
    required this.hasMore, required this.loading,
    this.owner,
    this.hideSearch,
    this.padding,
    this.home,
    this.type = '',
    this.range = '',
    this.search = '',
    this.search2 = '',
    this.rangeEndDate,
    this.rangeEndDate2,
    this.rangeStartDate,
    this.rangeStartDate2,
    this.type2 = ''

  }) : super(key: key);

  @override
  State<ApplyList> createState() => _ApplyListState();
}

class _ApplyListState extends State<ApplyList> {

  Future<AccountModel> geAccountDate () => AccountViewModel().getAccount();
  AccountModel? account;
  ShiftViewModel shiftViewModel = ShiftViewModel();
  List shifts = [];
  bool load = false;

  @override
  Widget build(BuildContext context) {
    bool rangeTitle= true;

    ScrollController? scrollController = widget.scrollController;
    if (!load)  {
      setState(() {
        shifts = widget.shifts;
        load = true;
      });
    }
    bool home = widget.home == true ? true: false;
    bool padding = widget.padding == true ? true: false;

    geAccountDate().then((value) {
      if (mounted) {
        setState(() {
          account = value;
        });
      }
    });

    padding ??= true;
    return ListView.builder(
        controller: scrollController,
        itemCount: shifts.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (shifts[index].runtimeType.toString() == "String") {
            return Column(
              children: [
                const SizedBox(height: 7,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.turn_slight_right_outlined, size: 20,),
                      const SizedBox(width: 5,),
                      Text(shifts[index], style: const TextStyle(
                          fontWeight: FontWeight.w700
                      ),)
                    ],
                  ),
                ),
              ],
            );
          } //else {
          return Column(
            children: [
              ApplyCard(
                padding: padding,
                shift: shifts[index],
              ),
              SizedBox(height: index == shifts.length - 1
                  ? 20
                  : 0)
            ],
          );
        }
    );
  }
}