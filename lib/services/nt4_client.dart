// lib/services/nt4_client.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:msgpack_dart/msgpack_dart.dart' as msgpack;
import 'package:logging/logging.dart';

class NT4Client extends ChangeNotifier {
  final _log = Logger('NT4Client');
  WebSocketChannel? _ws;
  bool _connected = false;
  final Map<String, dynamic> _topics = {};
  int _nextSubscriptionId = 1;
  final Map<String, int> _subscriptions = {};
  
  bool get isConnected => _connected;
  Map<String, dynamic> get topics => _topics;

  void connect({String host = 'localhost', int port = 5810}) {
    _log.info('Connecting to NT4 server at ws://$host:$port/nt/v4.0');
    
    try {
      _ws = WebSocketChannel.connect(
        Uri.parse('ws://$host:$port/nt/v4.0/ws'),
      );

      _ws!.stream.listen(
        (message) => _handleMessage(message as List<int>),
        onDone: _handleDisconnect,
        onError: (error) {
          _log.severe('WebSocket error: $error');
          _handleDisconnect();
        },
      );

      // Send initial subscription for robot state
      _subscribe('/SmartDashboard');
      _subscribe('/FMSInfo');
      _subscribe('/LiveWindow');
      
      _connected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      _log.severe('Failed to connect: $e');
      _handleDisconnect();
    }
  }

  void _handleMessage(List<int> rawMessage) {
    try {
      final message = msgpack.deserialize(Uint8List.fromList(rawMessage));
      if (message is! List) return;

      switch (message[0]) {  // Message type
        case 0x00:  // Publish
          _handlePublish(message);
          break;
        case 0x01:  // Subscription
          _handleSubscription(message);
          break;
        case 0x02:  // Properties
          _handleProperties(message);
          break;
      }
    } catch (e) {
      _log.warning('Error handling message: $e');
    }
  }

  void _handlePublish(List message) {
    final topicId = message[1];
    final value = message[3];
    
    if (_topics.containsKey(topicId)) {
      _topics[topicId] = value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _handleSubscription(List message) {
    final topicId = message[1];
    final name = message[2];
    final type = message[3];
    
    _topics[topicId] = null;  // Initialize topic
    _log.fine('Subscribed to topic: $name (id: $topicId, type: $type)');
  }

  void _handleProperties(List message) {
    // Handle properties updates
    _log.fine('Received properties update: $message');
  }

  void _subscribe(String prefix) {
    if (_ws == null || !_connected) return;

    final subId = _nextSubscriptionId++;
    _subscriptions[prefix] = subId;

    final message = msgpack.serialize([
      0x01,  // Subscribe
      subId,
      prefix,
      0x00,  // All types
      true,  // Prefix subscription
    ]);

    _ws!.sink.add(message);
  }

  void publish(String topic, dynamic value) {
    if (_ws == null || !_connected) return;

    final message = msgpack.serialize([
      0x00,  // Publish
      topic,
      DateTime.now().millisecondsSinceEpoch * 1000,  // timestamp in microseconds
      value,
    ]);

    _ws!.sink.add(message);
  }

  void _handleDisconnect() {
    _connected = false;
    _topics.clear();
    _subscriptions.clear();
    _ws?.sink.close();
    _ws = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    
    // Attempt to reconnect after delay
    Future.delayed(const Duration(seconds: 5), () {
      if (!_connected) connect();
    });
  }

  @override
  void dispose() {
    _ws?.sink.close();
    super.dispose();
  }
}