import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickdep_mob/data/response/status.dart';
import 'package:quickdep_mob/model/invoice/invoice_model.dart';
import 'package:quickdep_mob/resource/components/config/no_data_card.dart';
import 'package:quickdep_mob/resource/config/colors.dart';
import 'package:quickdep_mob/view_model/invoice/invoice_view_model.dart';

class InvoiceTab extends StatefulWidget {
  final bool paid;
  const InvoiceTab({Key? key, required this.paid}) : super(key: key);

  @override
  State<InvoiceTab> createState() => _InvoiceTabState();
}

class _InvoiceTabState extends State<InvoiceTab> {
  InvoiceViewModel invoiceViewModel = InvoiceViewModel();
  List<dynamic> invoices = [];
  bool isLoading = false;
  int currentPage = 1;
  bool fetched = false;

  @override
  Widget build(BuildContext context) {
    if (!fetched) {
      invoiceViewModel.fetchAllInvoicesListApi(context: context, paid: widget.paid);
      setState(() {
        fetched = true;
      });
    }

    return Center (
      child: ChangeNotifierProvider<InvoiceViewModel>(
          create: (BuildContext context) => invoiceViewModel,
          child: Consumer<InvoiceViewModel>(
              builder: (context, value, _){
                switch (value.invoicesList.status) {
                  case Status.LOADING:
                    return Center(
                      child: CupertinoActivityIndicator(radius: 15, color: AppColors.primaryColor,),
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.invoicesList.message.toString()),
                    );
                  case Status.COMPLETED:
                    if (invoices.isEmpty) {      // QuickDep#2022 Mot de passe QuickDep Info
                      invoices.addAll(value.invoicesList.data!);
                    }
                    if (invoices.isEmpty) {
                      return NoDataCard(message: "Aucune facture ${widget.paid ? 'payée' : 'à payer'} trouvée");
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30,),
                        Expanded(
                            child:
                            ListView.builder(
                                itemCount: invoices.length,
                                itemBuilder: (context, index) {
                                  InvoiceModel current = InvoiceModel.fromJson(invoices[index]);
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: const Offset(0, 4), // changes position of shadow
                                              ),
                                            ]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                        margin: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(current.code.toString(), style: TextStyle(
                                                    fontSize: 10,
                                                    color: AppColors.primaryColor,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                                InkWell(
                                                  onTap: () {
                                                    // invoiceViewModel.downloadInvoice(current.id, context: context);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: current.paid! ? CupertinoColors.activeGreen :Colors.orange
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                    child: Text(current.paid! ? "Payée" : "En attente du paiement", style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600
                                                    ),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            Text("Du ${DateFormat.yMEd().format(DateTime.parse(current.date.toString()).subtract(const Duration(days: 7)))} Au ${DateFormat.yMEd().format(DateTime.parse(current.date.toString()))}", style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor
                                            ),),
                                            const SizedBox(height: 20,),
                                            InkWell(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: AppColors.primaryColor
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (!invoiceViewModel.loadingDownload)
                                                        const Icon(Icons.download, color: Colors.white, size: 20),
                                                      if (invoiceViewModel.loadingDownload)
                                                        SizedBox(
                                                          height: 13,
                                                          width: 13,
                                                          child: CupertinoActivityIndicator(radius: 15, color: AppColors.primaryColor,),
                                                        ),
                                                      const SizedBox(width: 10,),
                                                      const Text("Télécharger (.pdf)", style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600
                                                      ),),
                                                    ],
                                                  )
                                              ),
                                              onTap: () async {
                                                if (!isLoading) {
                                                  await invoiceViewModel.downloadInvoicesApi(context: context, invoiceId: current.id!);
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20)
                                    ],
                                  );
                                }
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