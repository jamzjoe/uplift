import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/services/payment.dart';
import 'package:uplift/utils/widgets/button.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class DonationForm extends StatefulWidget {
  const DonationForm({
    super.key,
  });

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  List<String> amount = ['100', '200', '300'];
  String selectedAmount = '100';
  final TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: EdgeInsets.only(
          right: 30,
          left: 30,
          top: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HeaderText(text: 'How much wanna donate?', color: darkColor),
          defaultSpace,
          ...amount.map((e) => CustomContainer(
              onTap: () async {
                setState(() {
                  amountController.text = e;
                });
                await PayMongoService().createGCashLink(e, 'Uplift Donation');
              },
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              widget: SmallText(
                text: "$e pesos",
                color: darkColor,
                textAlign: TextAlign.center,
              ),
              color: primaryColor.withOpacity(0.1))),
          TextFormField(
            controller: amountController,
            onChanged: (value) {
              setState(() {
                selectedAmount = value;
              });
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                label: SmallText(text: 'Input manually', color: darkColor)),
          ),
          defaultSpace,
          CustomContainer(
            onTap: () async {
              await PayMongoService()
                  .createGCashLink(selectedAmount, 'Uplift Donation');
            },
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            widget: const SmallText(
              text: 'Continue',
              color: whiteColor,
              textAlign: TextAlign.center,
            ),
            color: primaryColor,
          )
        ],
      ),
    );
  }
}
