import 'package:flutter/material.dart';
import 'create_post_screen.dart'; // Import trang tạo bài đăng
import 'update_post_screen.dart'; // Import trang cập nhật bài đăng
import 'delete_post_screen.dart'; // Import trang xóa bài đăng
import 'dart:convert';
import 'package:http/http.dart' as http;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // Giả sử bạn có danh sách bài đăng từ API
  final String apiUrl = 'https://localhost:7266/api/Post'; // Thay đổi URL nếu cần

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((post) => post as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available.'));
          } else {
            final posts = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Account Details", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Điều hướng đến màn hình tạo bài đăng
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                    );
                  },
                  child: const Text('Create Post'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(post['image'], width: 50, height: 50),
                          title: Text('ID: ${post['id']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Điều hướng đến trang cập nhật bài đăng
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdatePostScreen(postId: post['id']),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Điều hướng đến trang xóa bài đăng
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeletePostScreen(postId: post['id']),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
