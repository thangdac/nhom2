import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeletePostScreen extends StatelessWidget {
  final int postId;

  const DeletePostScreen({super.key, required this.postId});

  final String apiUrl = 'https://localhost:7266/api/Post'; // Thay đổi URL nếu cần

  Future<void> deletePost(BuildContext context) async {  // Thêm BuildContext vào phương thức
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$postId'),
      );

      if (response.statusCode == 204) {
        print('Post deleted');
        Navigator.pop(context);  // Sử dụng context để quay lại màn hình trước
      } else {
        print('Failed to delete post: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Post'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure you want to delete this post?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                deletePost(context);  // Truyền context vào phương thức deletePost
              },
              child: const Text('Delete Post'),
            ),
          ],
        ),
      ),
    );
  }
}
