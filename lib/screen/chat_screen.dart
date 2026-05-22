import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String username;
  final String token;
  final int userId;

  const ChatScreen({Key? key, required this.username, required this.token, required this.userId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  void _connectSocket() {
    String host = 'localhost';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      host = '10.0.2.2';
    }

    socket = IO.io(
      'http://$host:8095', 
      <String, dynamic>{
        'transports': ['websocket'], 
        'upgrade': false, // EVITA que haga fallback a polling si el websocket es rechazado
        'forceNew': true,
        'autoConnect': false,
        'auth': {'token': widget.token},
        'query': {'token': widget.token},
        'extraHeaders': {'Authorization': 'Bearer ${widget.token}'},
      },
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint('Conectado al servidor de Socket.IO');
    });

    // Listeners para depurar problemas de conexión (ej. puerto incorrecto o rechazo)
    socket.onConnectError((error) {
      debugPrint('Error de conexión Socket.IO: $error');
    });

    socket.onError((error) {
      debugPrint('Error general Socket.IO: $error');
    });

    socket.onDisconnect((_) {
      debugPrint('Desconectado del servidor de Socket.IO');
    });

    socket.onReconnectAttempt((attempt) {
      debugPrint('Intentando reconectar... intento $attempt');
    });

    // Escucha eventos 'receive_message' desde el servidor
    socket.on('nuevo_mensaje', (data) {
      if (mounted) {
        setState(() {
          _messages.add({
            // Mapeamos las llaves que devuelve el backend (senderName y content) 
            // a las llaves que usa nuestra UI internamente (sender y text)
            'sender': data['senderName'] ?? data['sender'] ?? 'Desconocido',
            'text': data['content'] ?? data['text'] ?? '',
          });
        });
      }
    });

  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    
    // Emitimos el mensaje al servidor
    socket.emit('enviar_mensaje', {
      'senderName': widget.username,
      'content': messageText,
      'token': widget.token,
      'userId': widget.userId,
    });

        


    // Agregamos nuestro mensaje localmente a la lista
    setState(() {
      _messages.add({
        'sender': widget.username,
        'text': messageText,
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Global')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender'] == widget.username;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      isMe ? msg['text'] : '${msg['sender']}:\n${msg['text']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.dispose();
    super.dispose();
  }
}