import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickdep_mob/data/response/status.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/resource/components/config/no_data_card.dart';
import 'package:quickdep_mob/resource/components/listing/shift_list.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/services/filter_service.dart';
import 'package:quickdep_mob/view_model/shift/shift_view_model.dart';

class PublicShiftsTab extends StatefulWidget {
  final int id;
  const PublicShiftsTab({required this.id, Key? key}) : super(key: key);

  @override
  State<PublicShiftsTab> createState() => _PublicShiftsTabState();
}

class _PublicShiftsTabState extends State<PublicShiftsTab> {
  ShiftViewModel shiftViewModel = ShiftViewModel();
  List shifts = [];
  bool isLoading = false;
  int currentPage = 1;
  bool fetched = false;
  AccountModel? account;
  bool dataFetched = false;

  String? searchText;
  DateTime? startDate;
  DateTime? endDate;
  bool? hasDateFilter;
  bool? localHasDateFilter;

  @override
  Widget build(BuildContext context) {
    if (!fetched && account != null) {
      if (Utils.isEnterprise(account)) {
        shiftViewModel.fetchShiftListApi(context: context, enterpriseId: account!.enterprise!.id!);
      } else if (Utils.isWorker(account)) {
        shiftViewModel.fetchWorkerShiftListApi(context: context);
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

    FilterService().getSearch().then((value) {
      if (mounted) {
       setState(() {
        searchText = value;
      });
      }
    });

    FilterService().getStartDate().then((value) {
      if (mounted) {
       setState(() {
        startDate = value;
       });
      }
    });

    FilterService().getEndDate().then((value) {
      if (mounted) {
       setState(() {
        endDate = value;
       });
      }
    });

    FilterService().hasDateFilter().then((value) {
      if (mounted) {
       setState(() {
        hasDateFilter = value;
       });
      }
    });

    return Center (
      child: ChangeNotifierProvider<ShiftViewModel>(
          create: (BuildContext context) => shiftViewModel,
          child: Consumer<ShiftViewModel>(
              builder: (context, value, _){
                switch (value.shiftsList.status) {
                  case Status.LOADING:
                    return Center(
                      child: CupertinoActivityIndicator(radius: 15, color: AppColors.primaryColor,),
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.shiftsList.message.toString()),
                    );
                  case Status.COMPLETED:
                    if (value.shiftsList.data!.runtimeType.toString() == 'List<dynamic>') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Align(
                            alignment: Alignment.center,
                            child: NoDataCard(
                                message: value.shiftsList.data![0].toString()
                            ),
                          ))
                        ],
                      );
                    }

                    Map toAddData = {};

                    value.shiftsList.data!.forEach((d, dataValue) {
                      List toAddList = [];
                      for (var v in dataValue) {
                        ShiftModel dataShift = ShiftModel.fromJson(v);
                        bool addIt = true;

                        if (
                          searchText != null
                          && !dataShift.data!.job!.title.toString().toUpperCase().contains(searchText.toString().toUpperCase())
                          && !dataShift.data!.enterprise!.name.toString().toUpperCase().contains(searchText.toString().toUpperCase())
                        ) {
                          addIt = false;
                        }

                        if (startDate != null && startDate!.compareTo(DateTime.parse(dataShift.start.toString())) > 0) {
                          addIt = false;
                        }

                        if (endDate != null && endDate!.compareTo(DateTime.parse(dataShift.end.toString())) < 0) {
                          addIt = false;
                        }

                        if (addIt) {
                          toAddList.add(v);
                        }
                      }

                      if (toAddList.isNotEmpty) {
                        toAddData[d] = toAddList;
                      }
                    });

                    if (toAddData.isEmpty) {
                      return const Center(
                        child: NoDataCard(
                          message: "Aucun shift trouvé pour cette recherche",
                        ),
                      );
                    }

                    if (!dataFetched) {
                      shifts.addAll(Utils.getShiftsListFromMap(toAddData));
                      dataFetched = true;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ShiftList(
                              shifts: shifts,
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
              })
      ),
    );
  }
}