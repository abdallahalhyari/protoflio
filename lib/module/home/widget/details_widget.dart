import 'package:flutter/material.dart';

class DetailsWidget extends StatelessWidget {
   DetailsWidget({super.key,required this.image,required this.desc,required this.title,required this.titleDesc,required this.color});
   String image,title,desc,titleDesc;
   Color color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: .5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Hero(tag: title,child: image.contains('png')?Image.network(image,height:300):Image.asset(image,height: 300,)),
                  Text(title,style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.w600),),
                ],
              ),
            ),
            SizedBox(width: 100),
            SizedBox(width: 600,child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(maxLines:8,style: TextStyle(color: Colors.white,fontSize:40,fontWeight: FontWeight.bold),titleDesc),

                Text(maxLines:8,style: TextStyle(color: Colors.white,fontSize:20),desc),
              ],
            ))
          ],
        ),
      ),

    );
  }
}
