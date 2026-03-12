import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_controller.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String bookingId;
  final String peerName; // Nama lawan bicara (Guru/Murid)

  const ChatPage({super.key, required this.bookingId, required this.peerName});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _handleSend() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    // Panggil API Send Message
    final success = await ref
        .read(chatSendControllerProvider.notifier)
        .send(widget.bookingId, text);

    if (success && mounted) {
      _msgController.clear(); // Kosongkan kolom input

      // Refresh daftar chat agar pesan baru muncul
      ref.invalidate(chatListProvider(widget.bookingId));

      // Auto scroll ke bawah (opsional, dikasih delay sedikit agar UI ke-render dulu)
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Gagal mengirim pesan"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantau daftar chat dari API
    final chatAsync = ref.watch(chatListProvider(widget.bookingId));
    // Pantau status tombol kirim (loading/tidak)
    final isSending = ref.watch(chatSendControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
                backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=33"),
                radius: 18),
            const SizedBox(width: 12),
            Text(widget.peerName, style: const TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // --- AREA DAFTAR PESAN ---
          Expanded(
            child: chatAsync.when(
              data: (chats) {
                if (chats.isEmpty) {
                  return const Center(
                      child: Text("Belum ada pesan. Sapa duluan yuk!",
                          style: TextStyle(color: Colors.grey)));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final bool isMe =
                        chat['is_me'] ?? false; // Cek ini pesan kita atau dia

                    return _buildChatBubble(chat['message'] ?? "", isMe);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                  child: Text("Error: $err",
                      style: const TextStyle(color: Colors.red))),
            ),
          ),

          // --- AREA INPUT PESAN BAWAH ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) =>
                        _handleSend(), // Bisa enter dari keyboard
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor:
                      const Color(0xFFFF5E62), // Warna pink tema kita
                  child: isSending
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : IconButton(
                          icon: const Icon(Icons.send,
                              color: Colors.white, size: 18),
                          onPressed: _handleSend,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER: Menggambar Buble Chat Kiri/Kanan
  Widget _buildChatBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF5E62) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        // Batasi lebar chat max 75% layar
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          text,
          style: TextStyle(
              color: isMe ? Colors.white : Colors.black87, fontSize: 14),
        ),
      ),
    );
  }
}
