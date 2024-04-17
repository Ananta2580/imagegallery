import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:imagegallery/fullscreen_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoading = false;
  List _images = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchRandomImages() async {
    var image = [
      "beautiful girl", "red flowers", "yellow flowers", "fruit","mutton","dal",
      "white Flower", "Flower","Mens","Animals","birds","Tigers","lions","Krishna",
      "Hanuman","Mahadev"

    ];
    final random = Random();
    var photo = image[random.nextInt(image.length)];
    fetchImages(photo);
  }


  fetchImages(String query) async{
    setState(() {
      isLoading = true;
    });
    try{
      final String url =
          "https://pixabay.com/api/?key=43430157-11ee9edf29ffc59c73f09c367&q=$query&image_type=photo";
      Response response = await get(Uri.parse(url));

      if(response.statusCode == 200){
        setState(() {
          _images = json.decode(response.body)['hits'];
        });
      }
      setState(() {
        isLoading = false;
      });
    }catch(err){
      print(err.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var image = [
      "beautiful girl", "red flowers", "yellow flowers", "fruit","mutton","dal",
      "white Flower", "Flower","Mens","Animals","birds","Tigers","lions","Krishna",
      "Hanuman","Mahadev"

    ];
    final random = Random();
    var photo = image[random.nextInt(image.length)];
    fetchImages(photo);
    fetchRandomImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 45,
            child: TextFormField(
              style: TextStyle(color: Colors.white70,fontSize: 18),
              controller: searchController,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value){
                fetchImages(value);
              },
              decoration: InputDecoration(
                  hintText: "Search Images",
                  hintStyle: TextStyle(color: Colors.white70),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search,color: Colors.white,)
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchRandomImages,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading ? Center(child: CircularProgressIndicator(),) : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 4.0
              ),
              itemCount: _images.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) =>
                        FullScreenImage(imageUrl: _images[index]['largeImageURL'])));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Image.network(_images[index]['previewURL'],fit: BoxFit.cover,)
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.favorite,),
                              Text("${_images[index]['likes']}"),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.remove_red_eye),
                              Text("${_images[index]['views']}")
                            ],
                          ),

                        ],
                      )
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
