import 'dart:math';

import 'package:book_app_concept/book.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = PageController();
  final _notifierScroll = ValueNotifier(0.0);

  void _listener() {
    _notifierScroll.value = _controller.page ?? 0.0;
  }

  @override
  void initState() {
    _controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookHeight = size.height * 0.45;
    final bookWidth = size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookio', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(bookAppBackground, fit: BoxFit.fill)),
          ValueListenableBuilder<double>(
              valueListenable: _notifierScroll,
              builder: (context, value, _) {
                return PageView.builder(
                    itemCount: books.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      final percentage = index - value;
                      final rotation = percentage.clamp(0.0, 1.0);
                      // final fixRotation = pow(rotation, 0.1);

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Stack(
                              children: [
                                Container(
                                  height: bookHeight,
                                  width: bookWidth,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 20,
                                            offset: Offset(5.0, 5.0),
                                            spreadRadius: 10)
                                      ]),
                                ),
                                Transform(
                                  alignment: Alignment.centerLeft,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.002)
                                    ..rotateY(rotation * 1.7)
                                    ..translate(-rotation * size.width * 0.8)
                                    ..scale(1 + rotation * 0.2),
                                  child: Image.asset(
                                    book.image,
                                    fit: BoxFit.cover,
                                    height: bookHeight,
                                    width: bookWidth,
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(height: 90),
                            Opacity(
                              opacity: 1 - rotation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'By: ${book.author}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 20),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
              })
        ],
      ),
    );
  }
}
