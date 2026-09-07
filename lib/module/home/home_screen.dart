import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:profile/module/home/widget/details_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          // First Page
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/background.webp',
                  fit: BoxFit.cover,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.6,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius:screenWidth > 1200
                                    ? 160
                                    : screenWidth > 600
                                    ? 140
                                    : 90,
                                backgroundColor: Colors.brown.shade300,
                                backgroundImage:
                                Image.asset('assets/my_image.png').image,
                              ),
                            ),
                          ),
                          Positioned(
                           top:
                           screenWidth > 1200
                               ?  screenHeight/9
                               : screenWidth > 600
                               ?  screenHeight/9
                               :  screenHeight/5,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05),
                              child: Text(
                                'HELLO THERE!\nI\'M ABDALLAH',
                                style: TextStyle(
                                  fontSize: getResponsiveFontSize(40, context),
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Why Should Hire Me?',
                              style: TextStyle(
                                fontSize: getResponsiveFontSize(24, context),
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    _buildResponsiveButton(
                      context,
                      text: 'Scroll Down',
                      onPressed: () {},
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Lottie.asset('assets/arrow_white.json',
                        height: screenHeight * 0.1),
                  ],
                ),
              ),
            ],
          ),

          // Second Page
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/hats_background.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  height: screenHeight * 0.7,
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BECAUSE...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getResponsiveFontSize(24, context),
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'I WEAR MANY HATS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getResponsiveFontSize(40, context),
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        _buildResponsiveButton(
                          context,
                          text: 'Allow Me to Explain',
                          onPressed: () {},
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Lottie.asset('assets/arrow.json',
                            height: screenHeight * 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Third Page (Grid View)
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1200
                    ? 3
                    : constraints.maxWidth > 600
                    ? 3
                    : 2;
                return GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio:constraints.maxWidth > 1200
                      ? 1.3
                      : constraints.maxWidth > 600
                      ? 1.3
                      : .9 ,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: [
                    FadeInLeft(
                      child: _buildGridItem(
                        context,
                        color: Colors.brown.shade900.withOpacity(.9),
                        title: 'Thinking',
                        imageUrl:
                        'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608b4394cedd72e210c65688_Grad%20Cap.png',
                        titleDesc: 'I AM A QUICK LEARNER',
                          desc: 'There is nothing I love more than learning something new! This passion inspires me to jump into complex applications with excitement instead of fear. Because I have learned "how to learn" I will be able to quickly pick up new technical integrations and teach them.',
                          constraints: constraints
                      ),
                    ),
                    FadeInDown(
                      child: FadeInUp(
                        child: FadeInRight(
                          child: FadeInDown(
                            child: _buildGridItem(
                              context,
                              color: Colors.orange.shade900.withOpacity(.9),
                              title: 'Communicating',
                              imageUrl:
                              'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/609c3c4cfd6087595af9f4bd_Comms%20Hat.png',
                              titleDesc: 'I LISTEN CAREFULLY AND RESPOND CLEARLY',
                                desc: 'I believe the key to success in any industry, career, or relationship is clear communication. Over the years, I learned that listening is the first (and arguably most important) step in great communication. Thus, I challenged myself to become a great listener, which elevated my written and verbal communication skills to an expert level. I believe my communication skills will empower me to be successful in the Solutions Engineer position.',
                                constraints: constraints
                            ),
                          ),
                        ),
                      ),
                    ),
                    FadeInUpBig(
                      child: _buildGridItem(
                        context,
                        color: Colors.amber.shade700.withOpacity(.9),
                        title: 'Sorting',
                        imageUrl: 'assets/hat.png',
                        titleDesc: 'I AM WELL ORGANIZED',
                          desc: 'There is nothing worse than the feeling of needing something and not being able to find it. That\'s why I go through painstaking detail to not only get organized, but to stay organized. Being able to effectively compartmentalize information allows me to juggle multiple projects and clients simultaneously.',
                          constraints: constraints
                      ),
                    ),
                    FadeInDownBig(
                      child: _buildGridItem(
                        context,
                        color: Colors.red.shade800.withOpacity(.9),
                        title: 'Building',
                        imageUrl:
                        'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608b4394611cbb78872e2ccd_Hard%20Hat.png',
                        titleDesc: 'I LOVE MAKING THINGS',
                       desc: 'As an mobile developer, there is nothing more rewarding than starting with a app and ending with something meaningful. This passion for creation inspires me to meet new challenges head on with enthusiasm and determination. Whether I am building a app, you will often find me completely obsessed with learning the intricate details of new creative tools.',
                        constraints: constraints
                      ),
                    ),
                    FadeInDownBig(
                      child: _buildGridItem(
                        context,
                        color: Colors.green.shade700.withOpacity(.9),
                        title: 'Fixing',
                        imageUrl:
                        'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/609c3c4d8ed2f6dde086c99c_DT%20Hat.png',
                        titleDesc: 'I AM A PROBLEM SOLVER',
                          desc: 'My greatest strength is my resourcefulness. I love being challenged, and working my way toward "AH-HA" moments. The sense of pride I feel when I am able to solve problems for myself and others keeps me going at night, and gets me out of bed in the morning. The opportunity to achieve this feeling on a daily basis through the Solutions Engineer role gets me pumped up!',
                          constraints: constraints
                      ),
                    ),
                    FadeInDownBig(
                      child: _buildGridItem(
                        context,
                        color: Colors.deepPurple.shade700.withOpacity(.9),
                        title: 'Compassion',
                        imageUrl:
                        'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608c53df121d44d8d5ab6439_Nurses%20Cap.png',
                        titleDesc: 'I LIVE BY THE GOLDEN RULE',
                          desc: 'No matter the challenge, I always try to begin with empathy. Having a customer-first mindset is the key to providing lasting, meaningful solutions to problems. My high standard of excellence, relentless work ethic, and positive attitude are direct results of me "caring at a high level". I believe I will be an asset in Developer\'s mission of providing world-class customer support by practicing extraordinary kindness, and leading by serving others.',
                          constraints: constraints
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Contact Page
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/hats_background.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  height: screenHeight * 0.7,
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.black38,
                        Colors.black54,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'CONTACT INFORMATION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getResponsiveFontSize(40, context),
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        _buildContactInfo(
                          context,
                          label: 'EMAIL:',
                          value: 'alhyariabdallh@gmail.com',
                        ),
                        _buildContactInfo(
                          context,
                          label: 'PHONE:',
                          value: '+962-787032264',
                        ),
                        _buildLinkedIn(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveButton(
      BuildContext context, {
        required String text,
        required VoidCallback onPressed,
      }) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.black),
            elevation: const WidgetStatePropertyAll(3),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 1200
                  ? MediaQuery.of(context).size.width * 0.04
                  : constraints.maxWidth > 600
                  ? MediaQuery.of(context).size.width * 0.04
                  : MediaQuery.of(context).size.width * 0.01 ,
              vertical:constraints.maxWidth > 1200
                  ? MediaQuery.of(context).size.width * 0.01
                  : constraints.maxWidth > 600
                  ? MediaQuery.of(context).size.width * 0.01
                  : MediaQuery.of(context).size.width * 0.005,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFontSize(14, context),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildGridItem(
      BuildContext context, {
        required Color color,
        required String title,
        required String imageUrl,
        required String desc,
        required String titleDesc,
        required BoxConstraints constraints
      }) {
        return Container(
          color: color,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(
                      constraints.maxWidth > 1200
                          ? 24
                          : constraints.maxWidth > 600
                          ? 24
                          :  15
                      , context),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              Hero(
                tag: '$title Hat',
                child:imageUrl.contains('/hat.png')
                    ?Image.asset(
                  imageUrl,
                  height:constraints.maxWidth > 1200
                      ?  MediaQuery.of(context).size.height * 0.2
                      : constraints.maxWidth > 600
                      ?  MediaQuery.of(context).size.height * 0.2
                      :  MediaQuery.of(context).size.height * 0.09,
                ) :Image.network(
                  imageUrl,
                  height:constraints.maxWidth > 1200
                      ?  MediaQuery.of(context).size.height * 0.2
                      : constraints.maxWidth > 600
                      ?  MediaQuery.of(context).size.height * 0.2
                      :  MediaQuery.of(context).size.height * 0.09,
                ),
              ),
              Text(
                'Hat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: getResponsiveFontSize(  constraints.maxWidth > 1200
                      ? 24
                      : constraints.maxWidth > 600
                      ? 24
                      :  15, context),
                  fontWeight: FontWeight.w900,
                ),
              ),
              _buildResponsiveButton(
                context,
                text: 'Expand',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (cxt) => DetailsWidget(
                        color: color,
                        image: imageUrl,
                        title: '$title Hat',
                        desc: desc,
                        titleDesc: titleDesc,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );


  }

  Widget _buildContactInfo(BuildContext context,
      {required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontFamily: 'Tenada',
                fontSize: getResponsiveFontSize(20, context),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: 'Tenada',
                fontWeight: FontWeight.w100,
                fontSize: getResponsiveFontSize(18, context),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedIn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LINKEDIN: ',
            style: TextStyle(
              fontSize: getResponsiveFontSize(20, context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () {
              launchUrl(Uri.parse(
                  'https://www.linkedin.com/in/abdallah-alhyari-95b915201/'));
            },
            child: Text(
              'abdallah-alhyari',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: getResponsiveFontSize(18, context),
                color: Colors.blue.shade300,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double getResponsiveFontSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);
}