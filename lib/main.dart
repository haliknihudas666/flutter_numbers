import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> fetchNumberTrivia() async {
    try {
      final response =
          await http.get(Uri.parse('http://numbersapi.com/random/trivia'));

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to number trivia');
      }
    } on TimeoutException catch (_) {
      return 'Request Timeout. Please Try Again.';
    } on SocketException catch (e) {
      return 'Something went wrong. Please check your internet connection.\n${e.osError}';
    }
  }

  late Future<String> _numbersData;

  @override
  void initState() {
    _numbersData = fetchNumberTrivia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numbers'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<String>(
                future: _numbersData,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _numbersData = fetchNumberTrivia();
              });
            },
            child: const Text('Random'),
          )
        ],
      ),
    );
  }
}
