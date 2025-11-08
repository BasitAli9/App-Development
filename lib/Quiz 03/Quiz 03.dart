import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(home: FlashcardApp()));

class FlashcardApp extends StatefulWidget {
  const FlashcardApp({super.key});

  @override
  State<FlashcardApp> createState() => _FlashcardAppState();
}

class _FlashcardAppState extends State<FlashcardApp> {
  final _listKey = GlobalKey<AnimatedListState>();

  final _cards = [
    {'q': 'What is Flutter?', 'a': 'A UI toolkit by Google'},
    {'q': 'What is Dart?', 'a': 'The programming language used by Flutter'},
    {'q': 'What is a Widget?', 'a': 'A basic building block of UI'},
    {'q': 'What is setState?', 'a': 'Used to update the UI state'},
    {'q': 'What is Hot Reload?', 'a': 'Updates the app instantly while coding'},
  ];

  var _list = <Map<String, String>>[];
  var _learned = 0;

  @override
  void initState() {
    super.initState();
    _list = List.from(_cards);
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _learned = 0;
      _list = List.from(_cards)..shuffle(Random());
    });
  }

  void _remove(int i) {
    final card = _list[i];
    _listKey.currentState?.removeItem(
      i,
          (ctx, anim) => SizeTransition(sizeFactor: anim, child: _Card(card)),
    );
    setState(() {
      _list.removeAt(i);
      _learned++;
    });
  }

  void _addRandom() {
    final newCard = _cards[Random().nextInt(_cards.length)];
    setState(() => _list.insert(0, newCard));
    _listKey.currentState?.insertItem(0);
  }

  void _addCustom() async {
    final qCtrl = TextEditingController();
    final aCtrl = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: qCtrl, decoration: const InputDecoration(labelText: 'Question')),
            const SizedBox(height: 8),
            TextField(controller: aCtrl, decoration: const InputDecoration(labelText: 'Answer')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (qCtrl.text.isNotEmpty && aCtrl.text.isNotEmpty) {
                Navigator.pop(ctx, {'q': qCtrl.text, 'a': aCtrl.text});
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      _cards.add(result);
      setState(() => _list.insert(0, result));
      _listKey.currentState?.insertItem(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _list.length + _learned;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('$_learned of $total learned'),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedList(
                key: _listKey,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: _list.length,
                itemBuilder: (ctx, i, anim) => SizeTransition(
                  sizeFactor: anim,
                  child: Dismissible(
                    key: Key('${_list[i]['q']}$i'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => _remove(i),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                    child: _Card(_list[i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'random',
            onPressed: _addRandom,
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'custom',
            onPressed: _addCustom,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatefulWidget {
  final Map<String, String> data;
  const _Card(this.data);

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  var _show = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => setState(() => _show = !_show),
        child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _show ? Colors.lightBlueAccent : Colors.greenAccent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Text(
              _show ? widget.data['a']! : widget.data['q']!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            ),
        );
    }
}