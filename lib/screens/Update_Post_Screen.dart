import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdatePostScreen extends StatefulWidget {
  final int postId;

  const UpdatePostScreen({super.key, required this.postId});

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final String apiUrl = 'https://localhost:7266/api/Post'; // Thay đổi URL nếu cần

  @override
  void initState() {
    super.initState();
    // Bạn có thể lấy dữ liệu từ API và điền vào các controller
  }

  Future<void> updatePost(BuildContext context) async {  // Thêm BuildContext vào phương thức
    final title = _titleController.text;
    final description = _descriptionController.text;
    final image = _imageController.text;

    final Map<String, dynamic> postData = {
      'id': widget.postId,
      'name': title,
      'description': description,
      'image': image,
      'data': DateTime.now().toIso8601String(),
    };

    final String jsonPostData = json.encode(postData);

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${widget.postId}'), // Gửi yêu cầu đến API với id bài đăng
        headers: {'Content-Type': 'application/json'},
        body: jsonPostData,
      );

      if (response.statusCode == 204) {
        print('Post updated');
        Navigator.pop(context);  // Sử dụng context để quay lại màn hình trước
      } else {
        print('Failed to update post: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Post'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Image URL (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                updatePost(context);  // Truyền context vào phương thức updatePost
              },
              child: const Text('Update Post'),
            ),
          ],
        ),
      ),
    );
  }
}
