import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickdep_mob/data/response/status.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/resource/components/config/no_data_card.dart';
import 'package:quickdep_mob/resource/components/listing/approved_time_sheet_list.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/timeSheet/time_sheet_view_model.dart';

class ApprovedTimeSheetTab extends StatefulWidget {
  const ApprovedTimeSheetTab({Key? key}) : super(key: key);

  @override
  State<ApprovedTimeSheetTab> createState() => _ApprovedTimeSheetTabState();
}

class _ApprovedTimeSheetTabState extends State<ApprovedTimeSheetTab> {
  TimeSheetViewModel timeSheetViewModel = TimeSheetViewModel();
  List timSheets = [];
  bool isLoading = false;
  bool fetched = false;
  AccountModel? account;

  @override
  Widget build(BuildContext context) {
    if (!fetched && account != null) {
      timeSheetViewModel.fetchTimeSheetApproved(context: context);
      setState(() {
        fetched = true;
      });
    }

    AccountViewModel().getAccount().then((value) {
      if (mounted) {
        setState(() {
          account = value;
        });
      }
    });

    List timeSheets = [];

    return Center (
      child: ChangeNotifierProvider<TimeSheetViewModel>(
          create: (BuildContext context) => timeSheetViewModel,
          child: Consumer<TimeSheetViewModel>(
              builder: (context, value, _){
                switch (value.timeSheetsList.status) {
                  case Status.LOADING:
                    return Center(
                      child: CupertinoActivityIndicator(radius: 15, color: AppColors.primaryColor),
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.timeSheetsList.message.toString()),
                    );
                  case Status.COMPLETED:
                    if (value.timeSheetsList.data.runtimeType.toString() == 'List<dynamic>') {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Align(
                            alignment: Alignment.center,
                            child: NoDataCard(
                                message: "Vous n'avez aucune feuille de temps validée."
                            ),
                          ))
                        ],
                      );
                    }
                    if (timeSheets.isEmpty) {      // QuickDep#2022 Mot de passe QuickDep Info
                      timeSheets.addAll(Utils.getTimeSheetListFromMap(value.timeSheetsList.data!));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ApprovedTimeSheetList(
                              timeSheets: timeSheets, scrollController: null,
                            )
                        )
                      ],
                    );
                }
                return Container();
              })
      ),
    );
  }
}