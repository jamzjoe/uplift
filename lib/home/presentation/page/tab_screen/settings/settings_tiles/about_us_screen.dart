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
        title: HeaderText(text: 'About Us', color: lighter),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: ListView(
          children: [
            const Image(
                image: AssetImage('assets/uplift_colored_logo.png'),
                height: 40),
            defaultSpace,
            SmallText(
                text:
                    'The "Uplift" app is a transformative mobile platform designed to create a sacred space for the members of the Missionary Families of Christ community. It serves as a virtual sanctuary, empowering Catholics to deepen their relationship with God and one another through prayerful engagement and support. With a focus on fostering spiritual growth, unity, and compassion, Uplift aims to revolutionize the way Catholics connect, share their prayer intentions, and experience the profound joy of living a faith-centered life.',
                color: lighter),
            defaultSpace,
            HeaderText(text: 'Mission', color: lighter),
            SmallText(
                text:
                    'At Uplift, we are dedicated to building a sacred space for Catholics to come together, share their deepest prayer intentions, and find solace and support within a loving community. Our mission is to provide a platform that encourages spiritual growth, empowers individuals to make a positive impact through prayer, and fosters a sense of unity and belonging.',
                color: lighter),
            defaultSpace,
            HeaderText(text: 'Vision', color: lighter),
            SmallText(
                text:
                    'Our vision for Uplift is to create a virtual sanctuary where Catholics can deepen their relationship with God and one another. We envision an immersive platform that transcends borders, cultures, and differences, nurturing a vibrant ecosystem of prayerful engagement. By cultivating an atmosphere of love, compassion, and spiritual growth, we aim to empower individuals to discover their unique calling, actively contribute to the betterment of society, and experience the profound joy of living a faith-centered life.',
                color: lighter),
            defaultSpace,
            HeaderText(text: 'Developed', color: lighter),
            SmallText(
              text:
                  "The 'Uplift' app, developed by Digital Marketing Services for the church community, is a transformative mobile platform designed to create a sacred space for the members of the Missionary Families of Christ community. This innovative app serves as a virtual sanctuary, empowering Catholics to deepen their relationship with God and one another through prayerful engagement and support. Uplift is built with a strong focus on fostering spiritual growth, unity, and compassion among its users. It provides a range of features and functionalities that aim to revolutionize the way Catholics connect, share their prayer intentions, and experience the profound joy of living a faith-centered life. One of the key aspects of Uplift is its prayerful engagement feature. Users can access a variety of prayer resources, including daily reflections, scripture passages, and devotional materials. The app also offers a library of prayers and novenas to guide users in their personal prayer journey. Through these resources, Catholics can find inspiration, guidance, and solace in their faith.  Furthermore, Uplift offers a dedicated space for sharing prayer intentions. Users can submit their prayer requests, allowing the community to join together in lifting up these intentions to God. This collective prayer support creates a sense of unity and strengthens the bond among members, fostering a community of love and compassion. The app also incorporates social networking features that enable users to connect with one another. They can engage in discussions, participate in faith-based groups, and share uplifting messages and testimonies. By facilitating these connections, Uplift encourages Catholics to support and uplift each other in their spiritual journey. Overall, the 'Uplift' app developed by Digital Marketing Services is a remarkable tool for the Missionary Families of Christ community. By leveraging the power of technology, it creates a virtual sanctuary that fosters spiritual growth, strengthens community bonds, and deepens the Catholic faith experience. With Uplift, Catholics can embrace a faith-centered life in the modern digital age and find solace, support, and inspiration within the palm of their hands.",
              color: lighter,
            )
          ],
        ),
      ),
    );
  }
}
