import 'package:flutter/material.dart';
import 'package:profile/module/home/home_screen.dart';

class DetailsWidget extends StatelessWidget {
  DetailsWidget(
      {super.key,
      required this.image,
      required this.desc,
      required this.title,
      required this.titleDesc,
      required this.color});
  String image, title, desc, titleDesc;
  Color color;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        color: color,
        child: Wrap(
          alignment: WrapAlignment.center,
       crossAxisAlignment: WrapCrossAlignment.center,
       runAlignment: WrapAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Opacity(
                opacity: .5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Hero(
                        tag: title,
                        child: image.contains('/hat.png')
                            ?Image.asset(
                          image,
                          height: screenWidth > 1200
                              ? 300
                              : screenWidth > 600
                              ? 300
                              : 200,
                        ): Image.network(image,
                                height: screenWidth > 1200
                                    ? 300
                                    : screenWidth > 600
                                        ? 300
                                        : 200)
                            ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: getResponsiveFontSize(
                              screenWidth> 1200
                                  ? 40
                                  : screenWidth > 600
                                  ? 40
                                  :  30
                              , context),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                width: screenWidth > 1200
                    ? 500
                    : screenWidth > 600
                    ? 500
                    : 300,
                child: Wrap(
                  children: [
                    Text(
                        maxLines: 8,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:  getResponsiveFontSize(
                                screenWidth> 1200
                                    ? 40
                                    : screenWidth > 600
                                    ? 40
                                    :  20
                                , context),
                            fontWeight: FontWeight.bold),
                        titleDesc),
                    Text(
                        maxLines: 8,
                        style: TextStyle(fontWeight: FontWeight.w100,color: Colors.white, fontSize: getResponsiveFontSize(
                            screenWidth> 1200
                                ? 20
                                : screenWidth > 600
                                ? 20
                                :  15
                            , context),),
                        desc),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
