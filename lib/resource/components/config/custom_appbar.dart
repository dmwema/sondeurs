import 'package:flutter/material.dart';
import 'package:quickdep_mob/model/account/account_model.dart';
import 'package:quickdep_mob/resource/components/buttons/rounded_button.dart';
import 'package:quickdep_mob/resource/config/app_url.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/resource/components/form/form_field.dart';
import 'package:quickdep_mob/routes/routes_name.dart';
import 'package:quickdep_mob/utils/utils.dart';
import 'package:quickdep_mob/view_model/account/account_view_model.dart';
import 'package:quickdep_mob/view_model/services/filter_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  bool showBack;
  bool? hideNotificationIcon;
  bool showRefresh;
  String? backUrl;
  String? refreshUrl;

  CustomAppBar({Key? key, required this.title, this.showRefresh = false, this.showBack = false, this.hideNotificationIcon, this.backUrl}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomAppBarState extends State<CustomAppBar> {
  AccountModel? account;
  ImageProvider accountImg = const AssetImage('assets/logo/default-logo.png');

  final TextEditingController _searchController = TextEditingController();
  FilterService filterService = FilterService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    AccountViewModel().getAccount().then((value) {
      setState(() {
        account = value;

        if (account != null && account!.imagePath != null) {
          accountImg = NetworkImage("${AppUrl.domainName}/${account!.imagePath}");
        }
      });
    });

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        elevation: 0.0,
        leading: null,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child:  Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!widget.showBack)
                  InkWell(
                    onTap: () {
                      if (account != null) {
                        if (Utils.isWorker(account)) {
                          Navigator.pushNamed(context, RoutesName.workerProfile);
                        } else if (Utils.isEnterprise(account)) {
                          Navigator.pushNamed(
                              context, RoutesName.enterpriseProfile);
                        }
                      }
                    },
                    child:
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: accountImg,
                      backgroundColor: Colors.white,
                    ),
                  ),
                if (widget.showBack)
                  InkWell(
                    onTap: () {
                      if (widget.backUrl != null)  {
                        Navigator.pushNamed(context, widget.backUrl.toString());
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          const SizedBox(width: 10,),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white.withOpacity(.9)
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                // if(!widget.showBack)
                //   const Spacer(),
                if(!widget.showBack)
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (false && widget.hideNotificationIcon != true && !widget.showBack)
                      InkWell(
                        onTap: () {
                          AccountViewModel().addNotification().then((value) {
                            Navigator.pushNamed(context, RoutesName.notifications);
                          });
                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                              // if (notificationsCount != null && notificationsCount! > 0)
                                Positioned(
                                  top: -3,
                                  right: 2,
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xffc32c37),
                                          border: Border.all(color: Colors.white, width: 2)
                                        ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (!widget.showBack)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26, width: 1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!widget.showBack)
                              InkWell(
                                onTap: () {
                                  if (account != null && Utils.isWorker(account)) {
                                    Navigator.pushNamed(context, RoutesName.workerShifts);
                                  } else if (account != null && Utils.isEnterprise(account)) {
                                    Navigator.pushNamed(context, RoutesName.enterpriseShifts);
                                  }
                                },
                                child: const Icon(Icons.refresh_outlined),
                              ),
                              if (false &&  widget.showRefresh && !widget.showBack)
                              Container(
                                padding: const EdgeInsets.only(left: 5,),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            alignment: Alignment.topCenter,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    padding: const EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Text("Rechercher",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        const SizedBox(height: 20,),
                                                        CustomFormField(
                                                          label: 'Mot clé',
                                                          hint: 'Mot clé',
                                                          password: false,
                                                          controller: _searchController,
                                                          prefixIcon: const Icon(Icons.search),
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        const Text("Le mot clé peut être une partie du nom de l'entreprise ou du poste.",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black45
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        RoundedButton(
                                                          loading: false,
                                                          title: 'Rechercher',
                                                          onPress: () {
                                                            if (_searchController.text == '') {
                                                              Navigator.pop(context);
                                                            } else {
                                                              FilterService().updateSearch(_searchController.text);
                                                              _searchController.clear();
                                                              Navigator.pop(context);
                                                              Navigator.pushNamed(context, RoutesName.enterpriseShifts);
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  child: const Icon(Icons.search,),
                                ),
                              ),
                              // if (widget.showRefresh && !widget.showBack)
                              // Container(
                              //   padding: const EdgeInsets.only(left: 5,),
                              //   child: InkWell(
                              //     onTap: () {
                              //       FilterService().updateHasDateFilter(true);
                              //     },
                              //     child: const Icon(Icons.date_range_outlined,),
                              //   ),
                              // ),
                            ],
                          )
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0)
            )
        ),
        backgroundColor: Colors.white.withOpacity(0.0),
        iconTheme: IconThemeData(
            color: AppColors.primaryColor
        ),
      ),
    );
  }
}