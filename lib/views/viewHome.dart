import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_app/database/dbHelper.dart';
import 'dart:convert' as convert;
import 'package:jwt_app/widgets/homeList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_app/widgets/homeGrid.dart';
import 'package:jwt_app/views/viewFavs.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isGrid = true;

  @override
  void initState() {
    super.initState();
    viewMode();
    favSqlite();
  }

  Future<List> fetchProducts() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://192.168.20.20:3000/products'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('Response: $jsonResponse');
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> submitFav(String id) async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('http://192.168.20.20:3000/products/fav'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'productId': id,
      }),
    );
    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      await favSqlite();
      return response.body;
    } else if (response.statusCode == 400) {
      print('Response: ${response.body}');
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List> fetchFavs() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');
    final response = await http
        .get(Uri.parse('http://192.168.20.20:3000/products/fav'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('Response: $jsonResponse');
      print(response.body.runtimeType);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Future<void> favSqlite() async {
  //   try {
  //     var jsonResponse = await fetchFavs();
  //     for (final productData in jsonResponse) {
  //       await DbHelper.insertProduct(
  //           productData); // Insertar cada producto en la base de datos
  //     }
  //   } catch (e) {
  //     print('Error al insertar en la base de datos: $e');
  //     rethrow;
  //   }
  // }

  Future<void> favSqlite() async {
    try {
      var jsonResponse = await fetchFavs();
      for (var i = 0; i < jsonResponse.length; i++) {
        await DbHelper.insertProduct({
          'id': jsonResponse[i]['_id'],
          'name': jsonResponse[i]['name'],
          'owner': jsonResponse[i]['owner'],
          'rate': jsonResponse[i]['rate'].toString(),
          'image': jsonResponse[i]['image'],
        });
      }
      print('Favs insertados en la base de datos');
    } catch (e) {
      print('Error al insertar en la base de datos: $e');
      rethrow;
    }
  }

  void viewMode() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_isGrid == true) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Home'),
    //       actions: [
    //         IconButton(
    //           icon: _isGrid
    //               ? const Icon(Icons.list)
    //               : const Icon(Icons.grid_view),
    //           onPressed: viewMode,
    //         ),
    //       ],
    //     ),
    //     body: FutureBuilder<List>(
    //       future: fetchProducts(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return GridView.count(
    //               crossAxisCount: 2,
    //               children: List.generate(snapshot.data!.length, (index) {
    //                 return HomeGrid(
    //                   image: snapshot.data![index]['image'],
    //                   name: snapshot.data![index]['name'],
    //                   owner: snapshot.data![index]['owner'],
    //                   rate: snapshot.data![index]['rate'].toString(),
    //                 );
    //               }));
    //         } else if (snapshot.hasError) {
    //           return Text('${snapshot.error}');
    //         }
    //         return const CircularProgressIndicator();
    //       },
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Home'),
    //       actions: [
    //         IconButton(
    //           icon: _isGrid
    //               ? const Icon(Icons.list)
    //               : const Icon(Icons.grid_view),
    //           onPressed: viewMode,
    //         ),
    //       ],
    //     ),
    //     body: FutureBuilder<List>(
    //       future: fetchProducts(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return ListView.builder(
    //             itemCount: snapshot.data!.length,
    //             itemBuilder: (context, index) {
    //               return HomeList(
    //                 image: snapshot.data![index]['image'],
    //                 name: snapshot.data![index]['name'],
    //                 owner: snapshot.data![index]['owner'],
    //                 rate: snapshot.data![index]['rate'].toString(),
    //               );
    //             },
    //           );
    //         } else if (snapshot.hasError) {
    //           return Text('${snapshot.error}');
    //         }
    //         return const CircularProgressIndicator();
    //       },
    //     ),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                Get.to(const FavsView());
              }),
          IconButton(
            icon:
                _isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_view),
            onPressed: viewMode,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              prefs.remove('token');
              // final db = await DbHelper.database();
              await DbHelper.deleteProduct().then((value) => DbHelper.close());
              Get.offAllNamed('/');
            },
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_isGrid == true) {
              return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.635,
                  children: List.generate(snapshot.data!.length, (index) {
                    return HomeGrid(
                      id: snapshot.data![index]['_id'],
                      image: snapshot.data![index]['image'],
                      name: snapshot.data![index]['name'],
                      owner: snapshot.data![index]['owner'],
                      rate: snapshot.data![index]['rate'].toString(),
                      onPressed: () async {
                        await submitFav(snapshot.data![index]['_id']);
                      },
                    );
                  }));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return HomeList(
                      id: snapshot.data![index]['_id'],
                      image: snapshot.data![index]['image'],
                      name: snapshot.data![index]['name'],
                      owner: snapshot.data![index]['owner'],
                      rate: snapshot.data![index]['rate'].toString(),
                      onPressed: () async {
                        await submitFav(snapshot.data![index]['_id']);
                      });
                },
              );
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
