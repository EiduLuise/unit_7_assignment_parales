import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> characters;

  Future<List<dynamic>> fetchCharacters() async {
    final response =
        await http.get(Uri.parse('https://narutodb.xyz/api/character'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['characters'];
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  void initState() {
    super.initState();
    characters = fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UNIT 7 PARALES BSIT-3B"),
        backgroundColor: const Color.fromARGB(255, 255, 111, 0),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: characters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No characters available'));
          } else {
            var charactersList = snapshot.data!;
            return ListView.builder(
              itemCount: charactersList.length,
              itemBuilder: (context, index) {
                var character = charactersList[index];
                var imageUrl = character['images'] is List &&
                        (character['images'] as List).isNotEmpty
                    ? character['images'][0]
                    : 'https://via.placeholder.com/150';
                var name = character['name'];
                var debut = character['debut'] is Map
                    ? (character['debut'] as Map).values.join(', ')
                    : 'No debut available';
                var family = character['family'] is Map
                    ? (character['family'] as Map).values.join(', ')
                    : 'No family available';
                var jutsu = character['jutsu'] is List
                    ? (character['jutsu'] as List).join(', ')
                    : 'No jutsu available';
                var naturetype = character['natureType'] is List
                    ? (character['natureType'] as List).join(', ')
                    : 'No nature type available';
                var rank = character['rank'] is Map
                    ? (character['rank'] as Map).values.join(', ')
                    : 'No rank available';
                var tools = character['tools'] is List
                    ? (character['tools'] as List).join(', ')
                    : 'No tools available';
                var voiceactors = character['voiceActors'] is Map &&
                        (character['voiceActors'] as Map).isNotEmpty
                    ? (character['voiceActors'] as Map).values.join(', ')
                    : 'No voice actors available';
                var traits = (character['uniqueTraits'] is List &&
                        (character['uniqueTraits'] as List).isNotEmpty)
                    ? (character['uniqueTraits'] as List).join(', ')
                    : 'No special traits available';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Debut: $debut',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Family: $family',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Jutsu: $jutsu',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Nature Type: $naturetype',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Rank: $rank',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Tools: $tools',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Voice Actors: $voiceactors',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Unique Traits: $traits',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
