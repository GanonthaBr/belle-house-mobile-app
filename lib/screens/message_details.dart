import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';

class MessageDetailsScreen extends StatelessWidget {
  final String receiverName;
  final String receiverImage;

  MessageDetailsScreen({
    required this.receiverName,
    required this.receiverImage,
  });

  final List<Map<String, dynamic>> messages = [
    {
      'isSentByMe': true,
      'message': 'Hey, how are you?',
      'timestamp': '10:30 AM',
    },
    {
      'isSentByMe': false,
      'message': 'I am good, how about you?',
      'timestamp': '10:32 AM',
    },
    {
      'isSentByMe': true,
      'message': 'I am doing great, thanks!',
      'timestamp': '10:33 AM',
    },
    {
      'isSentByMe': false,
      'message': 'Let’s meet tomorrow.',
      'timestamp': '10:35 AM',
    },
    {
      'isSentByMe': true,
      'message': 'Sure, let me know the time.',
      'timestamp': '10:36 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(receiverImage),
              radius: AppDimension.distance30 / 1.5,
            ),
            SizedBox(width: AppDimension.distance20 / 2),
            TitleText(
              text: receiverName,
              fontSize: AppDimension.fontSize18,
              color: AppColors.secondaryColor,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: AppColors.secondaryColor),
            onPressed: () {
              // Call action
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: AppColors.secondaryColor),
            onPressed: () {
              // Video call action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.secondaryColor),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimension.distance20 / 2,
                vertical: AppDimension.distance20 / 2,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment:
                      message['isSentByMe']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: AppDimension.distance20 / 4,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.distance20,
                      vertical: AppDimension.distance20 / 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          message['isSentByMe']
                              ? AppColors.primaryColor
                              : AppColors.secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimension.radius14),
                        topRight: Radius.circular(AppDimension.radius14),
                        bottomLeft:
                            message['isSentByMe']
                                ? Radius.circular(AppDimension.radius14)
                                : Radius.zero,
                        bottomRight:
                            message['isSentByMe']
                                ? Radius.zero
                                : Radius.circular(AppDimension.radius14),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: TextStyle(
                            fontSize: AppDimension.fontSize18,
                            color:
                                message['isSentByMe']
                                    ? AppColors.secondaryColor
                                    : AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: AppDimension.distance20 / 4),
                        Text(
                          message['timestamp'],
                          style: TextStyle(
                            fontSize: AppDimension.fontSize18 * 0.7,
                            color:
                                message['isSentByMe']
                                    ? AppColors.secondaryColor.withOpacity(0.7)
                                    : AppColors.primaryColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Message Input
          Padding(
            padding: EdgeInsets.all(AppDimension.distance20 / 2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                        fontSize: AppDimension.fontSize18,
                        color: AppColors.primaryColor.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.secondaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimension.radius14,
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimension.distance20 / 2),
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: AppDimension.distance30 / 1.5,
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.secondaryColor),
                    onPressed: () {
                      // Send message action
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
