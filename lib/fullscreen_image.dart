import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage({super.key,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: FutureBuilder(
            future: precacheImage(NetworkImage(imageUrl), context),
            builder: (BuildContext context , AsyncSnapshot<void> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              else{
                return Center(
                  child: Hero(
                    tag: imageUrl,
                    child: Image.network(imageUrl),
                  ),
                );
              }
            }
        )
    );
  }
}
