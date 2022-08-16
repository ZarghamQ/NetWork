import 'package:flutter/material.dart';
import 'package:flutter_job_portal/screens/news/model.dart';
import 'package:flutter_job_portal/screens/news/news_api.dart';
import 'package:flutter_job_portal/screens/news/news_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsApiModel> newsList;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          newsList = value;
          isLoading = false;
        } else {
          print("List is Empty");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: size.height / 1.8,
          width: size.width,
          child: Column(
            children: [
              Container(
                height: size.height / 10,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Icon(
                      Icons.menu,
                      // color: Colors.white,
                    ),
                    SizedBox(
                      width: size.width / 4,
                    ),
                    Text(
                      "News App",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              isLoading
                  ? Container(
                      height: size.height / 30,
                      width: size.height / 30,
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: Container(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            return listItems(size, newsList[index]);
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItems(Size size, NewsApiModel model) {
    return Wrap(
      // padding: const EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),

      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReadingNews(
                model: model,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            width: size.width / 1.15,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  // height: size.height / 1,
                  width: size.width / 1.2,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  child: model.imageUrl != ""
                      ? Image.network(
                          model.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Text("Cant Load image"),
                ),
                //------------------Picture Border-----//
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    model.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                //--------Title----------//
                Container(
                  width: size.width / 1.1,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    model.description,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                //------- Description------//
              ],
            ),
          ),
        ),
      ],
    );
  }
}
