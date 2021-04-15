import 'package:flutter/material.dart';
import 'package:newsapp/views/article_view.dart';


class BlogTileSource extends StatelessWidget {

   final String title, desc , url;
   BlogTileSource({@required this.title,@required this.desc ,@required this.url });

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)  => ArticleView(blogUrl: url,)));
       },
            child: Container(
         margin: EdgeInsets.only(bottom:16),
         child: Card(
           
                    child: Column(
             children:[
               Text(title,style: TextStyle(color: Colors.black87, fontSize: 17 ,fontWeight: FontWeight.w600),),
              SizedBox(height:8.0),
              Text(desc, style: TextStyle(color: Colors.black54),),
              SizedBox(height:8.0),
             ]
            

           ),
         ),
         
       ),
     );
   }
 }