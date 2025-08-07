import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainTabbedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabbedScreen extends StatefulWidget {
  const MainTabbedScreen({super.key});
  @override
  State<MainTabbedScreen> createState() => _MainTabbedScreenState();
}

class _MainTabbedScreenState extends State<MainTabbedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
    );
  }

  void _openNewChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DummyContactSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'WhatsApp',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 21,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6.0, left: 4.0),
            child: IconButton(
              icon: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/11.jpg',
                ),
                radius: 14,
              ),
              onPressed: _goToProfile,
              tooltip: 'Profile',
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green.shade700,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.green.shade700,
          tabs: const [
            Tab(text: "CHATS"),
            Tab(text: "STATUS"),
            Tab(text: "CALLS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChatsTab(),
          StatusTab(),
          CallsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: _openNewChat,
              child: const Icon(Icons.chat, color: Colors.white),
              tooltip: 'New chat',
            )
          : null,
    );
  }
}

// Chats Tab
class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});
  static final List<Map<String, dynamic>> chats = [
    {
      'name': "Alice",
      'avatar':
          "https://randomuser.me/api/portraits/women/77.jpg",
      'lastMsg': "See you soon!",
      'time': "14:34",
      'unread': 2,
    },
    {
      'name': "Bob",
      'avatar':
          "https://randomuser.me/api/portraits/men/80.jpg",
      'lastMsg': "How's it going?",
      'time': "13:11",
      'unread': 0,
    },
    {
      'name': "Carlos",
      'avatar':
          "https://randomuser.me/api/portraits/men/28.jpg",
      'lastMsg': "Can't talk now.",
      'time': "Yesterday",
      'unread': 1,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, idx) {
        final chat = chats[idx];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chat['avatar']),
            radius: 26,
          ),
          title: Text(chat['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(chat['lastMsg']),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(chat['time'],
                  style: TextStyle(
                      fontSize: 13,
                      color: chat['unread'] > 0 ? Colors.green : Colors.grey)),
              if (chat['unread'] > 0)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    '${chat['unread']}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailsScreen(
                  name: chat['name'],
                  avatar: chat['avatar'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatDetailsScreen extends StatefulWidget {
  final String name;
  final String avatar;
  const ChatDetailsScreen({super.key, required this.name, required this.avatar});
  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final List<Map<String, dynamic>> messages = [
    {'fromMe': false, 'text': 'Hey!'},
    {'fromMe': true, 'text': 'Hello!'},
    {'fromMe': false, 'text': 'How are you?'},
    {'fromMe': true, 'text': 'I am good, how about you?'},
    {'fromMe': false, 'text': 'I\'m fine!'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMsg() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add({'fromMe': true, 'text': _controller.text.trim()});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatar),
              radius: 19,
            ),
            const SizedBox(width: 10),
            Text(widget.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 11),
              itemCount: messages.length,
              itemBuilder: (context, idx) {
                final msg = messages[idx];
                return Align(
                  alignment: msg['fromMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                    decoration: BoxDecoration(
                      color: msg['fromMe'] ? Colors.green[200] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['text']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      filled: true,
                      fillColor: Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMsg,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Status Tab
class StatusTab extends StatelessWidget {
  const StatusTab({super.key});
  static final List<Map<String, String>> statuses = [
    {
      'name': 'Alice',
      'avatar': 'https://randomuser.me/api/portraits/women/77.jpg',
      'text': 'Vacation mode! ☀️',
    },
    {
      'name': 'Sam',
      'avatar': 'https://randomuser.me/api/portraits/men/29.jpg',
      'text': 'Check out my new bike 🚲',
    },
    {
      'name': 'Lisa',
      'avatar': 'https://randomuser.me/api/portraits/women/88.jpg',
      'text': 'Sip sip, hooray for coffee!',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          child: Text('Recent updates',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        ...statuses.map((status) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(status['avatar']!),
              radius: 26,
            ),
            title: Text(status['name']!),
            subtitle: Text(status['text']!),
            onTap: () {},
          );
        }).toList()
      ],
    );
  }
}

// Calls Tab
class CallsTab extends StatelessWidget {
  const CallsTab({super.key});
  static final List<Map<String, dynamic>> calls = [
    {
      'name': 'Alice',
      'avatar': 'https://randomuser.me/api/portraits/women/77.jpg',
      'time': 'Today, 11:35',
      'type': 'incoming',
    },
    {
      'name': 'Sam',
      'avatar': 'https://randomuser.me/api/portraits/men/29.jpg',
      'time': 'Yesterday, 21:22',
      'type': 'outgoing',
    },
    {
      'name': 'Lisa',
      'avatar': 'https://randomuser.me/api/portraits/women/88.jpg',
      'time': 'Monday, 16:44',
      'type': 'missed',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, idx) {
        final call = calls[idx];
        IconData icon;
        Color iconColor;
        if (call['type'] == 'incoming') {
          icon = Icons.call_received;
          iconColor = Colors.green;
        } else if (call['type'] == 'outgoing') {
          icon = Icons.call_made;
          iconColor = Colors.blue;
        } else {
          icon = Icons.call_missed;
          iconColor = Colors.red;
        }
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(call['avatar']),
            radius: 26,
          ),
          title: Text(call['name']),
          subtitle: Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 5),
              Text(call['time'],
                  style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ],
          ),
          trailing: const Icon(Icons.call, color: Colors.green),
          onTap: () {},
        );
      },
    );
  }
}

// Profile Screen
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/men/11.jpg'),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              "Your Name",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              "Hey there! I am using WhatsApp.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('+1 234 567 8901'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('This is my status message!'),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyContactSelectionScreen extends StatelessWidget {
  const DummyContactSelectionScreen({super.key});
  static final List<Map<String, String>> contacts = [
    {
      'name': 'Manuel',
      'avatar': 'https://randomuser.me/api/portraits/men/66.jpg',
    },
    {
      'name': 'Sophia',
      'avatar': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'name': 'George',
      'avatar': 'https://randomuser.me/api/portraits/men/52.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start new chat")),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (context, idx) => const Divider(height: 1),
        itemBuilder: (context, idx) {
          final c = contacts[idx];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(c['avatar']!),
              radius: 26,
            ),
            title: Text(c['name']!),
            onTap: () {
              Navigator.pop(context);
              // This would actually start a chat in a full app.
            },
          );
        },
      ),
    );
  }
}
