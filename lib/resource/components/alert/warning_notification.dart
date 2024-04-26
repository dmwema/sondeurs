import 'package:flutter/material.dart';

class WarningNotification extends StatefulWidget {
  final String title;
  final String? route;
  final String color;
  final IconData? icon;
  bool padding = true;
  bool showModal;
  bool? phone;
  bool? btn;

  WarningNotification({
    Key? key,
    required this.title,
    this.route,
    this.showModal = false,
    required this.color,
    this.icon,
    this.btn,
    this.phone,
    this.padding = true
  }) : super(key: key);

  @override
  State<WarningNotification> createState() => _WarningNotificationState();
}

class _WarningNotificationState extends State<WarningNotification> {
  AccountModel account = AccountModel();
  Future<AccountModel> getAccountData () => AccountViewModel().getAccount();
  bool loading = false;

  AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    getAccountData ().then((value) {
      account = value;
    });

    return Padding(
        padding: widget.padding ? const EdgeInsets.only(left: 20, right: 20): EdgeInsets.zero,
        child:  InkWell(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  color: widget.color == "red" ? Colors.red.withOpacity(.3): Colors.orange.withOpacity(.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: widget.color == "red" ? Colors.red.withOpacity(.5): Colors.orange.withOpacity(.5),
                      width: 2
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Row(
                    children: [
                      Icon(widget.icon ?? Icons.warning_amber_rounded, color: widget.color == "red" ? Colors.red: Colors.orange, size: 18,),
                      const SizedBox(width: 10,),
                      Flexible(child: Text(widget.title, style: TextStyle(
                          color: Colors.black.withOpacity(.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      ),),),
                    ],
                  ),),
                  if (widget.btn == true)
                    const SizedBox(width: 10,),
                  if (widget.btn == true)
                    const Icon(Icons.chevron_right_rounded)
                ],
              )
          ),
          onTap: () {
            if (widget.showModal) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.black54,
                                size: 50,
                              ),
                              const SizedBox(height: 10,),
                              Column(
                                children: [
                                  if (widget.phone == null)
                                    Text("Un mail sera envoyé à votre adresse (${account.email}) pour finaliser la vérification.",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  if (widget.phone != null && widget.phone == true)
                                    Text("Un SMS sera envoyé à votre numéro de téléphone (${account.phoneNumber}) pour finaliser la vérification.",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  const Divider(),
                                  const Text("Êtes-vous sûr de vouloir continuer ?",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RoundedButton(
                                    title: "Confirmer",
                                    loading: loading,
                                    onPress: () {
                                      if (!loading) {
                                        setState(() {
                                          loading = true;
                                        });
                                        if (account.id != null) {
                                          if (widget.phone != null && widget.phone!) {
                                            authViewModel.phoneNumberVerification({}, context, account.id).then((value) {
                                              if (value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                Navigator.pushNamed(context, RoutesName.phoneNumberVerificationView);
                                              }
                                            });
                                          } else {
                                            authViewModel.emailVerification({}, context, account.id).then((value) {
                                              if (value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                Navigator.pushNamed(context, RoutesName.emailVerificationView);
                                              }
                                            });
                                          }
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10,),
                                  RoundedButton(
                                    title: "Annuler",
                                    loading: false,
                                    color: Colors.black38,
                                    onPress: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    );
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      )
                  )
              );
            } else {
              if (widget.route != null) {
                Navigator.pushNamed(context, widget.route.toString());
              }
            }
          },
        )
    );
  }
}