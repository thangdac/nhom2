import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook-fake Post'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/flutter_logo.png'),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Flutter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '2 giờ trước',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Flutter là một framework mã nguồn mở được phát triển bởi Google, giúp xây dựng ứng dụng di động, web và desktop từ một codebase duy nhất.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/flutter_banner.png', // Đặt hình ảnh mô tả bài post
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
