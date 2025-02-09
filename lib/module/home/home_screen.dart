import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:profile/module/home/widget/details_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/background.webp', // Ensure this image is added in pubspec.yaml
                  fit: BoxFit.cover,
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 500,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(shape:BoxShape.circle,color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircleAvatar(
                                radius: 180,
                                backgroundColor: Colors.brown.shade300,
                                backgroundImage: Image.asset('assets/my_image.png').image,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'HELLO THERE!\nI\'M ABDALLAH',
                              style: TextStyle(
                                fontSize: 65,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Why Should Hire Me  ?',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                        elevation: WidgetStatePropertyAll(3),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Scroll Down',style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Lottie.asset('assets/arrow_white.json',height: 100)
                ],
              ),
            ],
          ),

          Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/hats_background.webp', // Ensure this image is added in pubspec.yaml
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(height: 500,
                width: MediaQuery.sizeOf(context).width/1.3,
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [

                    Colors.black54,
                    Colors.black38,
                    Colors.black26,


                  ])),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('BECAUSE...',style: TextStyle(color: Colors.white,fontSize:30,fontWeight: FontWeight.w100),),
                        SizedBox(height:5),
                        Text('I WEAR MANY HATS',style: TextStyle(color: Colors.white,fontSize:60,fontWeight: FontWeight.w900),)
                       , SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.black),
                              elevation: WidgetStatePropertyAll(3),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Allow Me to Explain',style: TextStyle(color: Colors.white,fontSize: 18),),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Lottie.asset('assets/arrow.json',height: 200)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),


          SizedBox(
            height: MediaQuery.sizeOf(context).height/1.2,
            width: MediaQuery.sizeOf(context).width,
            child: GridView(
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                  mainAxisSpacing: 0,
          crossAxisSpacing: 0,
                  childAspectRatio:1.25
              ),
            children: [
              Container(color: Colors.brown.shade900.withOpacity(.9),
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Thinking',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.w900)),
                  Hero(tag: 'Thinking Cap',child: Image.network('https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608b4394cedd72e210c65688_Grad%20Cap.png',height:160,)),
                Text('Hat',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w900)),
                   ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (cxt)=>DetailsWidget(color: Colors.brown.shade900.withOpacity(.9),image: 'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608b4394cedd72e210c65688_Grad%20Cap.png',title: 'Thinking Cap',desc:'There is nothing I love more than learning something new! This passion inspires me to jump into complex applications (like Webflow, PhotoShop, and Logic Pro X) with excitement instead of fear. Because I have learned "how to learn" I will be able to quickly pick up new technical integrations and teach them to Webflow\'s enterprise clients.',titleDesc: 'I AM A QUICK LEARNER',)));
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        elevation: WidgetStatePropertyAll(3),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Expand',style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    ),
                  ),
                ],
              ),
              ),
              Container(color: Colors.orange.shade900.withOpacity(.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Communicating',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.w900)),
                      Hero(tag: 'Communicating hat',child: Image.network('https://uploads-ssl.webflow.com/608acc9573595051d044f20f/609c3c4cfd6087595af9f4bd_Comms%20Hat.png',height:160,)),
                    Text('Hat',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w900)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=>DetailsWidget(color: Colors.orange.shade900.withOpacity(.9),image: 'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/609c3c4cfd6087595af9f4bd_Comms%20Hat.png',title: 'Communicating hat',desc:'I believe the key to success in any industry, career, or relationship is clear communication. Over the years, I learned that listening is the first (and arguably most important) step in great communication. Thus, I challenged myself to become a great listener, which elevated my written and verbal communication skills to an expert level. I believe my communication skills will empower me to be successful in the Solutions Engineer position.',titleDesc: 'I LISTEN CAREFULLY AND RESPOND CLEARLY',)));
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          elevation: WidgetStatePropertyAll(3),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Expand',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(color: Colors.amber.shade700.withOpacity(.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Sorting',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.w900)),
                    Hero(tag:'Sorting hat',child: Image.asset('assets/hat.png',height:160,)),
                    Text('Hat',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w900)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=>DetailsWidget(color:Colors.amber.shade700.withOpacity(.9),image: 'assets/hat.png',title: 'Sorting hat',desc:'There is nothing worse than the feeling of needing something and not being able to find it. That\'s why I go through painstaking detail to not only get organized, but to stay organized. Being able to effectively compartmentalize information allows me to juggle multiple projects and clients simultaneously.',titleDesc: 'I AM WELL ORGANIZED',)));

                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          elevation: WidgetStatePropertyAll(3),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Expand',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ),
                    ),
                  ],
                ),),
              Container(color: Colors.red.shade800.withOpacity(.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Building',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.w900)),
                    Hero(tag: 'Building Hat',child: Image.network('https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608b4394611cbb78872e2ccd_Hard%20Hat.png',height:160,)),
                    Text('Hat',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w900)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=>DetailsWidget(color:Colors.red.shade800.withOpacity(.9),image: 'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608b4394611cbb78872e2ccd_Hard%20Hat.png',title: 'Building Hat',desc:'As an mobile developer, there is nothing more rewarding than starting with a app and ending with something meaningful. This passion for creation inspires me to meet new challenges head on with enthusiasm and determination. Whether I am building a app, you will often find me completely obsessed with learning the intricate details of new creative tools.',titleDesc: 'I LOVE MAKING THINGS',)));
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          elevation: WidgetStatePropertyAll(3),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Expand',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ),
                    ),
                  ],
                ),),
              Container(color: Colors.green.shade700.withOpacity(.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Fixing',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.w900)),
                    Hero(tag:'Fixing Hat',child: Image.network('https://uploads-ssl.webflow.com/608acc9573595051d044f20f/609c3c4d8ed2f6dde086c99c_DT%20Hat.png',height:160,)),
                    Text('Hat',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w900)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=>DetailsWidget(color:Colors.green.shade700.withOpacity(.9),image: 'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/609c3c4d8ed2f6dde086c99c_DT%20Hat.png',title: 'Fixing Hat',desc:'My greatest strength is my resourcefulness. I love being challenged, and working my way toward "AH-HA" moments. The sense of pride I feel when I am able to solve problems for myself and others keeps me going at night, and gets me out of bed in the morning. The opportunity to achieve this feeling on a daily basis through the Solutions Engineer role gets me pumped up!',titleDesc: 'I AM A PROBLEM SOLVER',)));

                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          elevation: WidgetStatePropertyAll(3),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Expand',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ),
                    ),
                  ],
                ),),
              Container(color: Colors.deepPurple.shade700.withOpacity(.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Compassion',style: TextStyle(color: Colors.white,fontSize: 38,fontWeight: FontWeight.w900)),
                    Hero(tag:'Compassion Hat',child: Image.network('https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608c53df121d44d8d5ab6439_Nurses%20Cap.png',height:160,)),
                    Text('Hat',style: TextStyle(color: Colors.white,fontSize: 28,fontWeight: FontWeight.w900)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (cxt)=>DetailsWidget(color:Colors.deepPurple.shade700.withOpacity(.9),image: 'https://uploads-ssl.webflow.com/608acc9573595051d044f20f/608c53df121d44d8d5ab6439_Nurses%20Cap.png',title: 'Compassion Hat',desc:'No matter the challenge, I always try to begin with empathy. Having a customer-first mindset is the key to providing lasting, meaningful solutions to problems. My high standard of excellence, relentless work ethic, and positive attitude are direct results of me "caring at a high level". I believe I will be an asset in Developer\'s mission of providing world-class customer support by practicing extraordinary kindness, and leading by serving others.',titleDesc: 'I LIVE BY THE GOLDEN RULE',)));
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          elevation: WidgetStatePropertyAll(3),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Expand',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ),
                    ),
                  ],
                ),),
            ],
          ),
          ),


          Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/hats_background.webp', // Ensure this image is added in pubspec.yaml
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(height: 500,
                  width: MediaQuery.sizeOf(context).width/1.3,
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [
                    Colors.black26,
                    Colors.black38,
                    Colors.black54,

                  ])),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('CONTACT INFORMATION',style: TextStyle(color: Colors.white,fontSize:60,fontWeight: FontWeight.w900),)
                        , SizedBox(height: 40),

                        Text('EMAIL :  alhyariabdallh@gmail.com',style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
                        SizedBox(height:20),
                        Text('PHONE :  +962-787032264',style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
                        SizedBox(height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('LINKEDIN : ',style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
                            InkWell(onTap: (){launchUrl(Uri.parse('https://www.linkedin.com/in/abdallah-alhyari-95b915201/'));},child: Text('abdallah-alhyari',style: TextStyle(color: Colors.blue.shade300,decorationColor: Colors.white,decoration: TextDecoration.underline,fontSize: 40,fontWeight: FontWeight.bold),)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
