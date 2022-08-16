// ignore_for_file: unused_local_variable, invalid_use_of_protected_member
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_job_portal/service/auth.dart';
import 'package:flutter_job_portal/.theme/colors.dart';
import 'package:flutter_job_portal/screens/authenticate/theme.dart';
import 'package:url_launcher/url_launcher.dart';

//user's response will be assigned to this variable
String job = '';
String uid = '';
List<News> topNews = [];
var collection = Firestore.instance.collection('users');

final AuthService _auth = AuthService();

//key created to interact with the form
final _formkey = GlobalKey<FormState>();

class Job {
  final String title;
  final String company;
  final String location;
  final String salary;
  final String url;

  Job(this.title, this.company, this.location, this.salary, this.url);
}

class News {
  final String title;
  final String description;
  final String photo_url;
  final String url;

  News(this.title, this.description, this.photo_url, this.url);
}

class HomePage extends StatelessWidget {
  Future<void> _savingData() async {
    final validation = _formkey.currentState.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState.save();
  }

  Stream<List<Job>> _getJobs() async* {
    final url = 'http://10.0.2.2:5000/job';
    final data = await http.get(Uri.parse(url));
    final decoded = json.decode(data.body);

    print(decoded.length);

    List<Job> jobs = [];
    for (var i in decoded) {
      Job job =
          Job(i['Title'], i['Company'], i['Location'], i['Salary'], i['Url']);
      jobs.add(job);
    }
    if (jobs.isEmpty != true) {
      yield jobs;
    }
  }

  const HomePage({Key key}) : super(key: key);
  Widget _appBar(BuildContext context) {
    // AppBar on top of screen
    return AppBar(
      backgroundColor: Colors.indigoAccent,
      title: Text(
        'network.',
        style: GoogleFonts.raleway(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          letterSpacing: .5,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Logout',
          onPressed: () async {
            await _auth.signOut();
          },
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Swipe to find your future!",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: .7,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: KColors.lightGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: _formkey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search job title or keywords',
                        hintStyle: GoogleFonts.raleway(
                          color: textGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onSaved: (value) {
                        job =
                            value; //getting data from the user form and assigning it to job
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              // Search Button that searches on press. Below.
              Container(
                decoration: BoxDecoration(
                  color: KColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                child: IconButton(
                  color: KColors.primary,
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () async {
                    _savingData();
                    final url = 'http://10.0.2.2:5000/job';
                    final response = await http.post(Uri.parse(url),
                        body: json.encode({'job': job}));
                    (context as Element).reassemble();
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _recommendedSection(BuildContext context) {
    _getNews() async {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/news'));
      final decoded = json.decode(response.body);

      print(decoded.length);

      for (var i in decoded) {
        News news = News(i['Title'], i['Description'], i['Photo_url'], i['Url']);
        topNews.add(news);
      }
      if (topNews.isEmpty != true) {
        return topNews;
      }
    }

    _getNews();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      margin: EdgeInsets.symmetric(vertical: 6),
      height: 210,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: .5,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i in topNews)
                  _newsArticle(context,
                      title: i.title, description: i.description, url: i.url)
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(
            "  Search results for $job ...",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsArticle(
    BuildContext context, {
    String title,
    String description,
    String url,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {},
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Container(
            decoration: BoxDecoration(
              color: isActive ? KColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: 40,
                //   width: 40,
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: isActive ? Colors.white : KColors.lightGrey,
                //     borderRadius: BorderRadius.circular(7),
                //   ),
                // ),
                SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive ? Colors.white38 : KColors.subtitle,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 8,
                    color: isActive ? Colors.white : KColors.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  url,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.white38 : KColors.subtitle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search results of jobs
  StreamBuilder<List<Job>> _jobSearch() {
    return StreamBuilder(
      stream: _getJobs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 100),
              child: Center(
                child: SpinKitDualRing(color: Colors.indigoAccent, size: 50.0),
              ));
        } else {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.attachment_outlined),
                    onPressed: () async {
                      await launch(snapshot.data[index].url,
                          forceSafariVC: false);
                    },
                  ),
                  title: Text(snapshot.data[index].company,
                      style: GoogleFonts.raleway(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .6,
                        fontSize: 16,
                      )),
                  subtitle: Text(snapshot.data[index].title,
                      style: GoogleFonts.raleway(
                        color: Colors.grey[700],
                        // fontWeight: FontWeight.w500,
                        letterSpacing: .6,
                        fontSize: 10,
                      )),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[900],
      // bottomNavigationBar: BottomMenuBar(),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(context),
                _header(context),
                _recommendedSection(context),
                _jobSearch(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
