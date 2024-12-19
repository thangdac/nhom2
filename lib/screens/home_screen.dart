import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Post>> fetchPosts() async {
    final String baseUrl= 'https://localhost:7266/api/Post'; // Đảm bảo URL đúng
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Fake Post'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(post.user?.profileImage ?? 'assets/default_profile.png'),
                              radius: 25,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.user?.name ?? 'Unknown User',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  post.data != null ? post.data!.toLocal().toString() : 'Unknown time',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          post.description ?? 'No description',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        post.image != null
                            ? Image.network(post.image!, fit: BoxFit.cover, width: double.infinity, height: 200)
                            : const SizedBox.shrink(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // Xử lý Thích
                              },
                              icon: const Icon(Icons.thumb_up_alt_outlined),
                              label: const Text('Thích'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // Xử lý Bình luận
                              },
                              icon: const Icon(Icons.comment_outlined),
                              label: const Text('Bình luận'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // Xử lý Chia sẻ
                              },
                              icon: const Icon(Icons.share_outlined),
                              label: const Text('Chia sẻ'),
                            ),
                          ],
                        ),
                      ],
                    ),
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

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
