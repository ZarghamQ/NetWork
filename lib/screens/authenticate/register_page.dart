import 'package:flutter_job_portal/screens/authenticate/login_page.dart';
import 'package:flutter_job_portal/service/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_job_portal/service/auth.dart';
import 'package:flutter_job_portal/shared/loading.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;
  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[900],
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.0, 36.0, 24.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/logo/logo.png',
                            width: 120,
                            height: 120,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Register new account',
                            style: GoogleFonts.raleway(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              letterSpacing: .9,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: textWhiteGrey,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: GoogleFonts.raleway(
                                    color: textGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() => name = val);
                                }),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: textWhiteGrey,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: GoogleFonts.raleway(
                                    color: textGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() => email = val);
                                }),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: textWhiteGrey,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: TextFormField(
                              obscureText: !passwordConfrimationVisible,
                              decoration: InputDecoration(
                                hintText: ' Password',
                                hintStyle: GoogleFonts.raleway(
                                  color: textGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                suffixIcon: IconButton(
                                  color: textGrey,
                                  splashRadius: 1,
                                  icon: Icon(passwordConfrimationVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () {
                                    setState(() {
                                      passwordConfrimationVisible =
                                          !passwordConfrimationVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        borderRadius: BorderRadius.circular(14.0),
                        color: primaryPurple,
                        child: Center(
                            child: Text(
                          'Register',
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: .9,
                          ),
                        )),
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() => loading = false);
                            } else {
                              DatabaseService(uid: result.uid)
                                  .updateUserData(name);
                            }
                          }
                        }),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.raleway(
                            color: textGrey,
                            fontSize: 16,
                            letterSpacing: .9,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.raleway(
                              color: Colors.indigoAccent,
                              fontSize: 16,
                              letterSpacing: .9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
