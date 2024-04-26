import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/resource/components/config/screen_argument.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/account_types.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/apply/apply_view_model.dart';
import 'package:quickdep_mob/view_model/shift/shift_view_model.dart';

class ApplyCard extends StatefulWidget {
  final ShiftModel shift;
  final bool padding;
  final bool? margin;

  const ApplyCard({
    super.key,
    required this.shift, required this.padding, this.margin
  });

  @override
  State<ApplyCard> createState() => _ApplyCardState();
}

class _ApplyCardState extends State<ApplyCard> {

  ApplyViewModel applyViewModel = ApplyViewModel();
  List<ShiftModel>? likes = [];
  int currentPage = 1;

  bool padding = false;
  bool margin = false;

  Future<AccountModel> getAccountData () => AccountViewModel().getAccount();
  AccountModel account = AccountModel();

  @override
  Widget build(BuildContext context) {
    if (widget.padding) {
      setState(() {
        padding = true;
      });
    } else {
      setState(() {
        padding = widget.padding;
      });
    }
    if (widget.margin != null) {
      setState(() {
        margin = widget.margin!;
      });
    }

    getAccountData ().then((value) {
      if (mounted) {
        setState(() {
          account = value;
        });
      }
    });

    initializeDateFormatting();
    Intl.defaultLocale = "fr_FR";

    var imgUrl = widget.shift.data!.enterprise!.account != null && widget.shift.data!.enterprise!.account!.imagePath != null
        ? AppUrl.domainName + widget.shift.data!.enterprise!.account!.imagePath.toString()
        : null;

    return Container(
      margin: margin ? const EdgeInsets.only(bottom: 20): null,
      padding: padding ? const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10): const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesName.waitingShiftDetail, arguments: ScreenArguments(widget.shift.data!.id!.toInt()));
        },
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 15),
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
                      ProfilePictureShimmer(),
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
                  Text(widget.shift.code!.toUpperCase(), style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue
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
                        child: Text(widget.shift.data!.job!.title.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_rounded, color: Colors.orange,),
                          if (Utils.isEnterprise(account))
                          const SizedBox(width: 5,),
                          if (Utils.isEnterprise(account))
                          const Icon(Icons.group_outlined),
                          if (Utils.isEnterprise(account))
                          const SizedBox(width: 2,),
                          if (Utils.isEnterprise(account))
                          Text(widget.shift!.count.toString(), style: const TextStyle(
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ],
                  ),
                  if (account.type != AccountType.enterprise)
                    const SizedBox(height: 3,),
                  if (account.type != AccountType.enterprise)
                    Text("Chez ${ widget.shift.data!.enterprise!.name.toString()}",style: TextStyle(
                        color: AppColors.lightPrimaryColor,fontSize: 12,fontWeight: FontWeight.bold
                    ),
                    ),
                  const SizedBox(height: 10,),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 5,
                    children: [
                      if (widget.shift.today != true)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.darkBlue, size: 13,
                            ),
                            const SizedBox(width: 4,),
                            Text(widget.shift.date!, style: TextStyle(
                                fontSize: 10,
                                color: AppColors.darkBlue
                            ),
                            ),
                          ],
                        ),
                      if (widget.shift.today == true)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.white, size: 13,
                              ),
                              SizedBox(width: 4,),
                              Text("Aujourd'hui", style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white
                              ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 10,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded,
                            color: AppColors.darkBlue, size: 14,),
                          const SizedBox(width: 4,),
                          Text("De ${widget.shift.startHour} à ${widget.shift.endHour}",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (widget.shift.consecutive!)
                    const SizedBox(height: 10,),
                  if (widget.shift.consecutive!)
                    Utils.consecutiveCard(),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${account.type == AccountType.worker ? widget.shift.data!.rate : (account.type == AccountType.enterprise ? widget.shift.data!.enterpriseRate: '')}\$/H",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue
                        ),
                      ),
                      const SizedBox(width: 5,),
                      if (widget.shift.data!.bonus != null && widget.shift.data!.bonus! > 0)
                        Text("+${widget.shift.data!.bonus}\$/H",
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green
                          ),
                        ),
                    ],
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
