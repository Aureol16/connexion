import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewData extends StatefulWidget {
  const ViewData({super.key});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  List userdata = [];
  bool isLoading = true; // Ajout d'un état de chargement

  Future<void> getrecord() async {
    String uri = "http://10.0.2.2/practice_api/view_data.php";

    try {
      var response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) { // Vérifie si la requête est OK
        setState(() {
          userdata = jsonDecode(response.body);
          isLoading = false; // Fin du chargement
        });
        print("Données récupérées : $userdata");
      } else {
        print("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur de connexion : $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getrecord(); // Appel de la fonction pour récupérer les données
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Data")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Affiche un loader
          : userdata.isEmpty
              ? const Center(child: Text("Aucune donnée disponible"))
              : ListView.builder(
                  itemCount: userdata.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(CupertinoIcons.heart),
                        title: Text(userdata[index]["uname"]),
                        subtitle: Text(userdata[index]["uemail"]),
                      ),
                    );
                  },
                ),
    );
  }
}
