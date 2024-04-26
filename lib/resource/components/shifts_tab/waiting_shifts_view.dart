import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickdep_mob/data/response/status.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/resource/components/config/no_data_card.dart';
import 'package:quickdep_mob/resource/components/listing/apply_list.dart';
import 'package:quickdep_mob/resource/components/listing/shift_list.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/apply/apply_view_model.dart';
import 'package:quickdep_mob/view_model/shift/shift_view_model.dart';

class WaitingShiftsTab extends StatefulWidget {
  final int id;
  const WaitingShiftsTab({required this.id, Key? key}) : super(key: key);

  @override
  State<WaitingShiftsTab> createState() => _WaitingShiftsTabState();
}

class _WaitingShiftsTabState extends State<WaitingShiftsTab> {
  ApplyViewModel applyViewModel = ApplyViewModel();
  List applies = [];
  bool isLoading = false;
  int currentPage = 1;
  bool fetched = false;
  AccountModel? account;

  @override
  Widget build(BuildContext context) {
    if (!fetched && account != null) {
      if (Utils.isWorker(account)) {
        applyViewModel.fetchWorkerAppliesApi(context: context, workerId: account!.worker!.id!);
      } else if (Utils.isEnterprise(account)){
        applyViewModel.fetchAppliesApi(context: context, enterpriseId: account!.enterprise!.id!);
      }
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

    return Center (
      child: ChangeNotifierProvider<ApplyViewModel>(
          create: (BuildContext context) => applyViewModel,
          child: Consumer<ApplyViewModel>(
              builder: (context, value, _){
                switch (value.appliesList.status) {
                  case Status.LOADING:
                    return Center(
                      child: CupertinoActivityIndicator(radius: 15, color: AppColors.primaryColor),
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.appliesList.message.toString()),
                    );
                  case Status.COMPLETED:
                    if (applies.isEmpty) {
                      if (value.appliesList.data.runtimeType.toString() == "List<dynamic>") {
                        return NoDataCard(message: value.appliesList.data![0]);
                      } else {
                        applies.addAll(Utils.getShiftsListFromMap(value.appliesList.data!));
                      }
                    }
                    if (applies.length == 1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Align(
                            alignment: Alignment.center,
                            child: NoDataCard(
                                message: applies[0].toString()
                            ),
                          ))
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ApplyList(
                              shifts: applies,
                              hasMore: true,
                              scrollController: null,
                              loading: false,
                              padding: true,
                              home: true,
                              hideSearch: true,
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