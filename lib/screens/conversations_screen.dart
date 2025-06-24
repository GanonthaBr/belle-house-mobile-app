import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';

class ConversationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = [
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'John Doe',
      'lastMessage': 'Hey, how are you?',
      'timestamp': '10:30 AM',
      'unreadCount': 2,
    },
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'Jane Smith',
      'lastMessage': 'Let’s meet tomorrow.',
      'timestamp': '9:15 AM',
      'unreadCount': 0,
    },
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'Michael Brown',
      'lastMessage': 'Thanks for the update!',
      'timestamp': 'Yesterday',
      'unreadCount': 5,
    },
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'Jane Smith',
      'lastMessage': 'Let’s meet tomorrow.',
      'timestamp': '9:15 AM',
      'unreadCount': 0,
    },
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'Michael Brown',
      'lastMessage': 'Thanks for the update!',
      'timestamp': 'Yesterday',
      'unreadCount': 5,
    },
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'Jane Smith',
      'lastMessage': 'Let’s meet tomorrow.',
      'timestamp': '9:15 AM',
      'unreadCount': 0,
    },
    {
      'receiverImage': 'images/logo.png',
      'receiverName': 'Michael Brown',
      'lastMessage': 'Thanks for the update!',
      'timestamp': 'Yesterday',
      'unreadCount': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: AppDimension.distance50 * 2.5,
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              // background: Image(image: AssetImage('images/sofa.png')),
              title: TitleText(
                text: 'Conversations',
                fontSize: AppDimension.fontSize18 * 1.3,
                color: AppColors.secondaryColor,
              ),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: AppColors.secondaryColor,
                  size: AppDimension.radius14 * 2.5,
                ),
                onPressed: () {
                  // Search action
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.secondaryColor,
                  size: AppDimension.radius14 * 2.5,
                ),
                onPressed: () {
                  // More options
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final conversation = conversations[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.distance20 / 3,
                  vertical: AppDimension.distance20 / 1.5,
                ),
                child: ListTile(
                  // horizontalTitleGap: 40,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(conversation['receiverImage']),
                    radius: AppDimension.distance30,
                  ),
                  title: Text(
                    conversation['receiverName'],
                    style: TextStyle(
                      fontSize: AppDimension.fontSize18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      fontSize: AppDimension.fontSize18 * 0.8,
                      color: AppColors.primaryColor.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        conversation['timestamp'],
                        style: TextStyle(
                          fontSize: AppDimension.fontSize18 * 0.7,
                          color: AppColors.primaryColor.withOpacity(0.7),
                        ),
                      ),
                      if (conversation['unreadCount'] > 0)
                        Container(
                          margin: EdgeInsets.only(
                            top: AppDimension.distance20 / 4,
                          ),
                          padding: EdgeInsets.all(AppDimension.distance20 / 10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(
                              AppDimension.distance50 * 2,
                            ),
                          ),
                          child: Text(
                            '${conversation['unreadCount']}',
                            style: TextStyle(
                              fontSize: AppDimension.fontSize18 * 0.7,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/message_details');
                    // Navigate to chat screen
                  },
                ),
              );
            }, childCount: conversations.length),
          ),
        ],
      ),
    );
  }
}
