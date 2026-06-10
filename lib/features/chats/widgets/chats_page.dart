import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/chat_preview_model.dart';
import 'package:vynce_frontend/features/events/data/services/chats_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  ChatsService chatsService = getIt<ChatsService>();
  List<ChatPreview> chats = [];
  List<ChatPreview> filteredChats = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadChats();
    _searchController.addListener(_filterChats);
  }

  Future<void> _loadChats() async {
    var res = await chatsService.getChatPreviews();
    setState(() {
      chats = res.data;
      filteredChats = res.data;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats() {
    if (chats.isEmpty) return;
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredChats = query.isEmpty
          ? chats
          : chats.where((c) => c.name.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bodySearchBar(),
          _onlineNow(),
          Expanded(child: _chatSection()),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: 70,
      title: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: Text('Mensagens'),
      ),
    );
  }

  Widget _bodySearchBar() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.1), width: 0.5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: Colors.black38),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar conversa...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onlineNow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            "ONLINE AGORA",
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(spacing: 12, children: _avatars()),
        ),
      ],
    );
  }

  List<Widget> _avatars() {
    final mocks = chats;

    return mocks
        .map(
          (m) => GestureDetector(
            onTap: () {
              context.push("chats/" + (m.chatId as String));
            },
            child: Column(
              spacing: 6,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: m.online as bool ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(m.img as String),
                  ),
                ),
                Text(
                  m.name as String,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _chatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            "CONVERSAS",
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
        Expanded(child: ListView(children: _chats())),
      ],
    );
  }

  List<Widget> _chats() {
    final mocks = filteredChats;

    return mocks.map((m) {
      var eventRaw = m.event as String;
      var event = eventRaw.length < 40 ? eventRaw : eventRaw.substring(0, 40);
      var isMyMessage = m.lastMessageUserId as String == m.userId;
      return ListTile(
        onTap: () {
          context.push("chats/" + (m.chatId as String));
        },
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(m.img as String),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: m.online as bool ? Colors.green : Colors.grey,

                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          m.name as String,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              m.lastMessage as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Color(int.parse(m.hostColor as String)),
                  width: 1,
                ),
                color: Color(int.parse(m.hostColor as String)).withOpacity(0.1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  event,
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(int.parse(m.hostColor as String)),
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              m.time as String,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 4),
            isMyMessage
                ? Icon(
                    Icons.done_all,
                    size: 18,
                    color: (m.unread as bool)
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.4),
                  )
                : SizedBox.shrink(),
          ],
        ),
      );
    }).toList();
  }
}
