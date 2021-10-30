import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:aws_amplify/amplifyconfiguration.dart';
import 'package:aws_amplify/models/ModelProvider.dart';
import 'package:aws_amplify/todoView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AWS Amplify test"),
      ),
      body:_isAmplifyConfigured ? TodoView(): _loader(),
    );
  }
  
  Widget _loader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _configureAmplify() async {
    
    try {
      final dataStorePlugin =
          AmplifyDataStore(modelProvider: ModelProvider.instance);
      await Amplify.addPlugin(dataStorePlugin);
      await Amplify.addPlugin(AmplifyAPI());
      // await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      print("Amplify configure successful");

      setState(() => _isAmplifyConfigured = true);
    } catch (e) {
      print("Error configuring Amplify");
    }
  }
}
