import 'package:flutter/material.dart';
import 'package:uplift/constant/constant.dart';
import 'package:uplift/utils/widgets/header_text.dart';
import 'package:uplift/utils/widgets/small_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HeaderText(text: 'About Us', color: secondaryColor),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: ListView(
          children: const [
            SmallText(
                text:
                    'The "Uplift" app is a transformative mobile platform designed to create a sacred space for the members of the Missionary Families of Christ community. It serves as a virtual sanctuary, empowering Catholics to deepen their relationship with God and one another through prayerful engagement and support. With a focus on fostering spiritual growth, unity, and compassion, Uplift aims to revolutionize the way Catholics connect, share their prayer intentions, and experience the profound joy of living a faith-centered life.',
                color: secondaryColor),
            defaultSpace,
            HeaderText(text: 'Mission', color: secondaryColor),
            SmallText(
                text:
                    'At Uplift, we are dedicated to building a sacred space for Catholics to come together, share their deepest prayer intentions, and find solace and support within a loving community. Our mission is to provide a platform that encourages spiritual growth, empowers individuals to make a positive impact through prayer, and fosters a sense of unity and belonging.',
                color: secondaryColor),
            defaultSpace,
            HeaderText(text: 'Vision', color: secondaryColor),
            SmallText(
                text:
                    'Our vision for Uplift is to create a virtual sanctuary where Catholics can deepen their relationship with God and one another. We envision an immersive platform that transcends borders, cultures, and differences, nurturing a vibrant ecosystem of prayerful engagement. By cultivating an atmosphere of love, compassion, and spiritual growth, we aim to empower individuals to discover their unique calling, actively contribute to the betterment of society, and experience the profound joy of living a faith-centered life.',
                color: secondaryColor)
          ],
        ),
      ),
    );
  }
}
