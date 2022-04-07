import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var subscription;
  String status= "Offline";

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
    .onConnectivityChanged
    .listen((ConnectivityResult result) {
      if(result != ConnectivityResult.none){
        setState(() {
           status = "Online";
        });
      }else{
        setState(() {
          status = "Offline";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancle();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: status== "Offline"? Colors.redAccent : Colors.greenAccent ,
            child: Center(
              child: Text(status),
            )),
          preferredSize: const Size(
            double.maxFinite,
            4.0
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async{
                //checkInternet();
                String statusOfInternet = await getConectvity();
                final snackBar = SnackBar(
                  content: Text(statusOfInternet),
                  duration: const Duration(seconds: 5),
                );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }, 
              child: const Text(" Get Status")
            )
          ],
        ),
      ),
    
    );
  }
}
checkInternet() async{
  bool result = await InternetConnectionChecker().hasConnection;
  if(result == true){
    print("Wifi Connected");
  }else{
    print("No internet");
  }
}
Future<String> getConectvity() async{
  var result = await (Connectivity().checkConnectivity());
  if(result == ConnectivityResult.wifi){
    return  "Wifi Connected " ;
  } else if(result == ConnectivityResult.mobile){
    return "Mobile Data Connected";
  }else{
    return "No internet";
  }
}
