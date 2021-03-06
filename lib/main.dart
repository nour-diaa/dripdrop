import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_repository.dart';
import 'authentication/authentication_bloc.dart';
import 'authentication/authentication_event.dart';
import 'authentication/authentication_state.dart';
import 'pages/login_page.dart';
import 'package:dripdrop/pages/drop_page.dart';
import 'package:dripdrop/pages/home_page.dart';


import 'package:flutter/services.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationStarted());
      },
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  _AppState createState() => _AppState();

  
}

class _AppState extends State<App> {

  @override
  void initState() {

    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Open Sans",
        backgroundColor: Color(0xFF1D1D1D),
        cardColor: Color(0xFFBDC0C7),
        accentColor: Color(0xFF0DA2CA),
        splashColor: Color(0xFFFDB223),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
              fontFamily: "Corp Trial",
              fontWeight: FontWeight.w700,
              color: Color(0xFF0DA2CA)),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 10,
              color: Color(0xFF0DA2CA),
              style: BorderStyle.solid,
            ),
          ),
        ),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                fontFamily: "Nasalization",
                fontSize: 20,
                color: Color(0xFF0DA2CA)),
            headline6: TextStyle(
                fontFamily: "Software Tester 7",
                color: Colors.black,
                fontSize: 20)),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return Container();
          }
          if (state is AuthenticationSuccess) {
            // return DropPage();
            return HomePage();
          }
          if (state is AuthenticationFailure) {
            return LoginPage(userRepository: widget.userRepository);
          }
          if (state is AuthenticationInProgress) {
            return Text("Loading");
          } else {
            return null;
          }
        },
      ),
    );
  }
}
