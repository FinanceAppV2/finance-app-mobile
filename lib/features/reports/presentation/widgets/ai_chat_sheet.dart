import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../controllers/reports_controller.dart';

class AiChatSheet extends StatefulWidget {
  const AiChatSheet({super.key});

  @override
  State<AiChatSheet> createState() => _AiChatSheetState();
}

class _AiChatSheetState extends State<AiChatSheet> {
  final _controller = GetIt.instance<ReportsController>();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _includeReportsData = true;
  bool _isLoading = false;
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(
      const _ChatMessage(
        text: 'Olá! Sou o assistente financeiro. Como posso ajudar você a analisar seus gastos hoje?',
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messageController.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await _controller.generateAi(
      message: text,
      includeReportsData: _includeReportsData,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _messages.add(
        _ChatMessage(
          text: response ?? 'Erro ao obter resposta. Tente novamente.',
          isUser: false,
          isError: response == null,
        ),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildToggleRow(),
          const Divider(color: AppColors.linha, height: 1),
          Expanded(child: _buildMessages()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.lataoClaro.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.lataoClaro,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Assistente IA',
                style: TextStyle(
                  color: AppColors.marfim,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppColors.cinza),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.cinza.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Enviar dados dos relatórios',
              style: TextStyle(
                color: AppColors.cinza.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
          ),
            SizedBox(
            height: 24,
            child: Switch.adaptive(
              value: _includeReportsData,
              activeTrackColor: AppColors.lataoClaro,
              onChanged: (v) => setState(() => _includeReportsData = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.lataoClaro,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Pensando...',
                  style: TextStyle(color: AppColors.cinza, fontSize: 13),
                ),
              ],
            ),
          );
        }

        final msg = _messages[index];
        return _ChatBubble(message: msg);
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: AppColors.marfim, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Digite sua pergunta...',
                hintStyle: TextStyle(
                  color: AppColors.cinza.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _onSend(),
            ),
          ),
          IconButton(
            onPressed: _isLoading ? null : _onSend,
            icon: Icon(
              Icons.send_rounded,
              color: _isLoading
                  ? AppColors.nevoa
                  : AppColors.lataoClaro,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: message.isUser
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.latao
              : AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isUser
                ? const Radius.circular(16)
                : Radius.zero,
            bottomRight: message.isUser
                ? Radius.zero
                : const Radius.circular(16),
          ),
        ),
        child: message.isUser
            ? Text(
                message.text,
                style: const TextStyle(
                  color: AppColors.marfim,
                  fontSize: 14,
                  height: 1.4,
                ),
              )
            : MarkdownBody(
                data: message.text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  textAlign: WrapAlignment.start,
                  p: const TextStyle(
                    color: AppColors.marfim,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  h1: const TextStyle(
                    color: AppColors.lataoClaro,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  h2: const TextStyle(
                    color: AppColors.lataoClaro,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  h3: const TextStyle(
                    color: AppColors.lataoClaro,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  strong: const TextStyle(
                    color: AppColors.lataoClaro,
                    fontWeight: FontWeight.bold,
                  ),
                  em: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                  code: const TextStyle(
                    color: AppColors.latao,
                    fontSize: 13,
                    fontFamily: 'monospace',
                    backgroundColor: AppColors.elevado,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: AppColors.superficie,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: AppColors.latao.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  listBullet: const TextStyle(
                    color: AppColors.lataoClaro,
                  ),
                  horizontalRuleDecoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.nevoa.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
