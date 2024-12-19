import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // API URL của bạn
  final String apiUrl = 'https://localhost:7266/api/Post'; // Thay đổi đường dẫn nếu cần

  Future<void> createPost() async {
    // Lấy dữ liệu từ các controller
    final title = _titleController.text;
    final description = _descriptionController.text;
    final image = _imageController.text;

    // Tạo một đối tượng Map từ dữ liệu nhập vào
    final Map<String, dynamic> postData = {
      'name': title,
      'description': description,
      'image': image,
      'data': DateTime.now().toIso8601String(), // Dữ liệu có thể là ngày hiện tại
    };

    // Chuyển đổi Map thành JSON
    final String jsonPostData = json.encode(postData);

    // Gửi yêu cầu HTTP POST đến API
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonPostData,
      );

      if (response.statusCode == 201) {
        // Thành công, bạn có thể xử lý kết quả trả về từ API
        final Map<String, dynamic> newPost = json.decode(response.body);
        print('Post created: ${newPost['name']}');
        Navigator.pop(context); // Quay lại trang trước sau khi đăng bài
      } else {
        // Xử lý lỗi khi không thành công
        print('Failed to create post: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề bài đăng
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Mô tả bài đăng
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Ảnh bài đăng
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Nút đăng bài
              ElevatedButton(
                onPressed: createPost,
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
