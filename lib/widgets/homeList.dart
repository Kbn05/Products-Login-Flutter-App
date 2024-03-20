import 'package:flutter/material.dart';

class HomeList extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final String owner;
  final String rate;
  final Function() onPressed;

  const HomeList({
    Key? key,
    required this.id,
    required this.image,
    required this.name,
    required this.owner,
    required this.rate,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        color: const Color.fromARGB(255, 129, 129, 129),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              image,
              width: 70,
              height: 90,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: $name'),
                  Text('Owner: $owner'),
                  Text('Rate: $rate'),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.star),
                  onPressed: onPressed,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
