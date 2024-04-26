import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/timeSheet/time_sheet_model.dart';
import 'package:quickdep_mob/resource/components/config/screen_argument.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/account_types.dart';
import 'package:quickdep_mob/utils/time_sheet_status.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/timeSheet/time_sheet_view_model.dart';

class TimeSheetCard extends StatefulWidget {
  final TimeSheetModel timeSheet;

  const TimeSheetCard({
    super.key,
    required this.timeSheet,
  });

  @override
  State<TimeSheetCard> createState() => _TimeSheetCardState();
}

class _TimeSheetCardState extends State<TimeSheetCard> {

  TimeSheetViewModel timeSheetViewModel = TimeSheetViewModel();

  bool padding = false;
  bool margin = false;

  Future<AccountModel> getAccountData () => AccountViewModel().getAccount();
  AccountModel account = AccountModel();

  @override
  Widget build(BuildContext context) {
    getAccountData ().then((value) {
      if (mounted) {
        setState(() {
          account = value;
        });
      }
    });

    initializeDateFormatting();
    Intl.defaultLocale = "fr_FR";

    var imgUrl = widget.timeSheet.shift!.enterprise!.account != null && widget.timeSheet.shift!.enterprise!.account!.imagePath != null
        ? AppUrl.domainName + widget.timeSheet.shift!.enterprise!.account!.imagePath.toString()
        : null;

    Icon? icon;
    if (Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent) {
      icon = const Icon(Icons.edit_note, color: Colors.orange,);
    } else if (widget.timeSheet.data!.status == TimeSheetStatus.waiting) {
      icon = const Icon(Icons.history_rounded, color: Colors.orange,);
    } else if (widget.timeSheet.data!.status == TimeSheetStatus.notSent) {
      icon = const Icon(Icons.edit_note, color: Colors.orange,);
    } else {
      icon = const Icon(Icons.check_circle_outline_rounded, color: Colors.green,);
    }

    return Container(
      margin: margin ? const EdgeInsets.only(bottom: 20): null,
      padding: padding ? const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10): const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          if (widget.timeSheet.data!.status == TimeSheetStatus.notSent && Utils.isEnterprise(account)) {
            return;
          }
          Navigator.pushNamed(context, RoutesName.timeSheetDetail, arguments: ScreenArguments(widget.timeSheet.data!.id!.toInt()));
        },
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 15),
          margin: const EdgeInsets.only(left: 15, right: 20, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const ProfilePictureShimmer(),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: imgUrl != null
                              ? DecorationImage(
                            image: NetworkImage(imgUrl),
                            fit: BoxFit.cover,
                          ) : const DecorationImage(
                              image: AssetImage("assets/logo/default-logo.jpg")
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(widget.timeSheet.code!.toUpperCase(), style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                          ? AppColors.darkBlue.withOpacity(.4) : AppColors.darkBlue
                  ),)
                ],
              ),
              const SizedBox(width: 10,),

              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(widget.timeSheet.shift!.job!.title.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                  ? AppColors.primaryColor.withOpacity(.4) : AppColors.primaryColor
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          icon,
                        ],
                      ),
                    ],
                  ),
                  if (Utils.isWorker(account))
                    const SizedBox(height: 3,),
                  if (Utils.isWorker(account))
                    Text("Chez ${ widget.timeSheet.data!.shiftDate!.shift!.enterprise!.name.toString()}",style: TextStyle(
                        color: AppColors.lightPrimaryColor,fontSize: 12,fontWeight: FontWeight.bold
                    ),
                    ),
                  const SizedBox(height: 10,),
                  Wrap(
                    alignment: WrapAlignment.start,
                    runSpacing: 5,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                ? AppColors.darkBlue.withOpacity(.4) : AppColors.darkBlue, size: 14,
                          ),
                          const SizedBox(width: 4,),
                          Text(widget.timeSheet.date!,
                            style: TextStyle(
                              fontSize: 10,
                              color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                ? AppColors.darkBlue.withOpacity(.4) : AppColors.darkBlue
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded,
                            color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                ? AppColors.darkBlue.withOpacity(.4) : AppColors.darkBlue, size: 14,),
                          const SizedBox(width: 4,),
                          Text("De ${widget.timeSheet.startHour} à ${widget.timeSheet.endHour}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                ? AppColors.darkBlue.withOpacity(.4) : AppColors.darkBlue
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${account.type == AccountType.worker ? widget.timeSheet.shift!.rate : (account.type == AccountType.enterprise ? widget.timeSheet.shift!.enterpriseRate: '')}\$/H",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                ? AppColors.darkBlue.withOpacity(.4) : AppColors.darkBlue
                        ),
                      ),
                      const SizedBox(width: 5,),
                      if (widget.timeSheet.shift!.bonus != null && widget.timeSheet.shift!.bonus! > 0)
                        Text("+${widget.timeSheet.shift!.bonus}\$/H",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent
                                  ? Colors.green.withOpacity(.4) : Colors.green
                          ),
                        ),
                    ],
                  ),
                  if (Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent)
                  const SizedBox(height: 10,),
                  if (Utils.isEnterprise(account) && widget.timeSheet.data!.status == TimeSheetStatus.notSent)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(.5),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note, color: Colors.white, size: 17,),
                          SizedBox(width: 5,),
                          Text("En attente du travailleur", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white
                          ),)
                        ],
                      ),
                    ),
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
