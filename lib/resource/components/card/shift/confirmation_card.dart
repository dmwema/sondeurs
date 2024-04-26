import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep_mob/model/shift/shift_model.dart';
import 'package:quickdep_mob/resource/components/config/screen_argument.dart';
import 'package:quickdep_mob/resource/components/shimmer/profile_picture_shimmer.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/account_types.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/confirmation/confirmation_view_model.dart';

class ConfirmationCard extends StatefulWidget {
  final ShiftConfirmationModel data;
  final bool padding;
  final bool? margin;

  const ConfirmationCard({
    super.key,
    required this.data, required this.padding, this.margin
  });

  @override
  State<ConfirmationCard> createState() => _ConfirmationCardState();
}

class _ConfirmationCardState extends State<ConfirmationCard> {

  ConfirmationViewModel confirmationViewModel = ConfirmationViewModel();
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

    var imgUrl = widget.data.data!.shift!.enterprise != null && widget.data!.data!.shift!.enterprise!.account != null && widget.data.data!.shift!.enterprise!.account!.imagePath != null
        ? AppUrl.domainName + widget.data.data!.shift!.enterprise!.account!.imagePath.toString()
        : null;

    return Container(
      margin: margin ? const EdgeInsets.only(bottom: 20): null,
      padding: padding ? const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10): const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesName.confirmationShiftDetail, arguments: ScreenArguments(widget.data.data!.id!.toInt()));
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
                  Text(widget.data.code!.toUpperCase(), style: TextStyle(
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
                        child: Text(widget.data.data!.shift!.job!.title.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor
                          ),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 25,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (Utils.isWorker(account))
                    const SizedBox(height: 3,),
                  if (Utils.isWorker(account))
                    Text("Chez ${ widget.data.data!.shift!.enterprise!.name.toString()}",style: TextStyle(
                        color: AppColors.lightPrimaryColor,fontSize: 12,fontWeight: FontWeight.bold
                    ),
                    ),
                  const SizedBox(height: 10,),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 5,
                    children: [
                      if (widget.data.today != true)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.darkBlue, size: 13,
                            ),
                            const SizedBox(width: 4,),
                            Text(widget.data.date!, style: TextStyle(
                                fontSize: 10,
                                color: AppColors.darkBlue
                            ),
                            ),
                          ],
                        ),
                      if (widget.data.today == true)
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
                          Text("De ${widget.data.startHour} à ${widget.data.endHour}",
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.darkBlue,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  if (widget.data.consecutive!)
                    const SizedBox(height: 10,),
                  if (widget.data.consecutive!)
                    Utils.consecutiveCard(),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${account.type == AccountType.worker ? widget.data.data!.shift!.rate : (account.type == AccountType.enterprise ? widget.data.data!.shift!.enterpriseRate: '')}\$/H",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue
                        ),
                      ),
                      const SizedBox(width: 5,),
                      if (widget.data.data!.shift!.bonus != null && widget.data.data!.shift!.bonus! > 0)
                        Text("+${widget.data.data!.shift!.bonus}\$/H",
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
