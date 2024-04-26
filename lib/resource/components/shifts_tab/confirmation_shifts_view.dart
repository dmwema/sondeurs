import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickdep_mob/data/response/status.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/resource/components/config/no_data_card.dart';
import 'package:quickdep_mob/resource/components/listing/confirmation_list.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/confirmation/confirmation_view_model.dart';

class ConfirmationShiftsTab extends StatefulWidget {
  final int id;
  const ConfirmationShiftsTab({required this.id, Key? key}) : super(key: key);

  @override
  State<ConfirmationShiftsTab> createState() => _ConfirmationShiftsTabState();
}

class _ConfirmationShiftsTabState extends State<ConfirmationShiftsTab> {
  ConfirmationViewModel confirmationViewModel = ConfirmationViewModel();
  List confirmations = [];
  bool isLoading = false;
  int currentPage = 1;
  bool fetched = false;
  AccountModel? account;

  @override
  Widget build(BuildContext context) {
    if (!fetched && account != null) {
      if (Utils.isWorker(account)) {
        confirmationViewModel.fetchWorkerConfirmationsApi(context: context, workerId: account!.worker!.id!);
      } else if (Utils.isEnterprise(account)) {
        confirmationViewModel.fetchConfirmationsApi(context: context, enterpriseId: account!.enterprise!.id!);
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
      child: ChangeNotifierProvider<ConfirmationViewModel>(
          create: (BuildContext context) => confirmationViewModel,
          child: Consumer<ConfirmationViewModel>(
              builder: (context, value, _){
                switch (value.confirmationsList.status) {
                  case Status.LOADING:
                    return Center(
                      child: CupertinoActivityIndicator(color: AppColors.primaryColor, radius: 15,)
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.confirmationsList.message.toString()),
                    );
                  case Status.COMPLETED:
                    if (confirmations.isEmpty) {
                      if (value.confirmationsList.data.runtimeType.toString() == "List<dynamic>") {
                        return NoDataCard(message: value.confirmationsList.data![0]);
                      } else {
                        confirmations.addAll(Utils.getConfirmationsListFromMap(value.confirmationsList.data!));
                      }
                    }
                    if (confirmations.length == 1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Align(
                            alignment: Alignment.center,
                            child: NoDataCard(
                                message: confirmations[0].toString()
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
                            child: ConfirmationList(
                              shifts: confirmations,
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
              }
          )
      ),
    );
  }
}