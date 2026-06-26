import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/chat_model.dart';
import 'package:vynce_frontend/core/models/message_model.dart';
import 'package:vynce_frontend/core/services/chats_service.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/navigation/extensions/safe_navigation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.id});
  final String id;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatsService chatsService = getIt<ChatsService>();
  ChatModel? chat;
  List<MessageModel> messages = [];
  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showEmojiPicker = false;

  Future<void> _loadChat() async {
    var res = await chatsService.getChat(widget.id);
    setState(() {
      chat = res.data;
      messages = chat!.messages;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (chat == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Column(
        children: [
          _eventCardSection(context),
          Expanded(child: _messagesSection()),
          _messageInput(),
          if (_showEmojiPicker)
            EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _messageController.text += emoji.emoji;
              },
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: 70,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        ),
      ),
      title: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _userData(),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.block, color: Colors.red, size: 20),
                      Text(
                        'Bloquear usuário',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'block') {
                  // TODO: bloquear usuário
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _userData() {
    return Row(
      spacing: 8,
      children: [
        Container(
          decoration: BoxDecoration(
            color: chat!.online ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(3),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(chat!.friend.avatarUrl),
          ),
        ),
        Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat!.friend.name,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              ),
            ),
            chat!.online
                ? Text(
                    'Online agora',
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  )
                : Text(
                    'Offline',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _eventCardSection(BuildContext context) {
    final event = chat!.event;
    final eventColor = event?.color != null
        ? Color(int.parse(event!.color))
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () => context.push('/events/${chat!.event!.id}'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: eventColor.withOpacity(0.3), width: 1),
            color: eventColor.withOpacity(0.05),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: event?.imageUrl != null
                    ? Image.network(
                        event!.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : Container(width: 48, height: 48, color: eventColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event?.title ?? 'Evento',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      event != null ? _getLocTime() : '',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: eventColor),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocTime() {
    final date = chat!.event!.date;
    final day = date.day;
    final month = DateFormat('MMM', 'pt_BR').format(date);
    final hour = date.hour;
    final city = chat!.event!.city;
    return '$day $month · ${hour}h · $city';
  }

  Widget _messageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Digite uma mensagem...',
                  hintStyle: TextStyle(fontSize: 12),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  prefixIcon: IconButton(
                    constraints:
                        BoxConstraints(), // 👈 remove padding fixo do IconButton
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      size: 20,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() => _showEmojiPicker = !_showEmojiPicker);
                    },
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_messageController.text.trim().isEmpty) return;

              final newMessage = MessageModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                profileId: chat!.profile.id,
                friendId: chat!.friend.id,
                read: false,
                sent: true,
                mine: true,
                textMessage: _messageController.text.trim(),
                createdAt: DateTime.now(),
              );
              setState(() {
                messages = [...messages, newMessage];
                _messageController.clear();
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messagesSection() {
    return ListView.separated(
      reverse: false,
      controller: _scrollController,

      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: messages.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (_, index) => _messageBubble(messages[index]),
    );
  }

  Widget _messageBubble(MessageModel message) {
    final isMe = message.mine;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: isMe ? Radius.circular(16) : Radius.circular(4),
                bottomRight: isMe ? Radius.circular(4) : Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.textMessage,
                  style: TextStyle(
                    color: isMe
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                if (isMe) ...[
                  SizedBox(height: 2),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: message.read
                        ? Colors.blue
                        : Theme.of(
                            context,
                          ).colorScheme.surface.withOpacity(0.6),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
