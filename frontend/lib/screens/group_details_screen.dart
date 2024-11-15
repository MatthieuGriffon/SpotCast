import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/member_card.dart';

enum UserRole { admin, member, visitor }

UserRole _userRole = UserRole.visitor;

class GroupDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> group;
  final String currentUser;

  const GroupDetailsScreen({
    super.key,
    required this.group,
    required this.currentUser,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _memberController = TextEditingController();

  final List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _memberController.dispose();
    super.dispose();
  }

  // Vérifier le rôle de l'utilisateur (admin, member, visitor)
  void _checkUserRole() {
    final roles = widget.group['roles'];
    final normalizedUser = widget.currentUser.trim().toLowerCase();

    if (roles['admin']
        .any((admin) => admin.trim().toLowerCase() == normalizedUser)) {
      setState(() => _userRole = UserRole.admin);
    } else if (roles['members']
        .any((member) => member.trim().toLowerCase() == normalizedUser)) {
      setState(() => _userRole = UserRole.member);
    } else {
      setState(() => _userRole = UserRole.visitor);
    }
  }

  // Ajouter un nouveau membre
  void _addMember() {
    final newMember = _memberController.text.trim();
    if (newMember.isNotEmpty &&
        !widget.group['roles']['members'].contains(newMember)) {
      setState(() {
        widget.group['roles']['members'].add(newMember);
      });
      _memberController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ce membre existe déjà !')),
      );
    }
  }

  void _toggleMembership() {
    setState(() {
      if (_userRole == UserRole.visitor) {
        _userRole = UserRole.member;
        widget.group['roles']['members'].add(widget.currentUser);
      } else if (_userRole == UserRole.member) {
        _userRole = UserRole.visitor;
        widget.group['roles']['members'].remove(widget.currentUser);
      }
    });
  }

  // Supprimer un membre (admin uniquement)
  void _removeMember(String member) {
    setState(() {
      widget.group['roles']['members'].remove(member);
    });
  }

  // Ajouter un message au chat
  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        messages.insert(0, {
          'sender': widget.currentUser,
          'message': messageText,
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;

    return Scaffold(
      appBar: AppBar(
        title: Text(group['name'] ?? 'Détails du Groupe'),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupInfo(group),
            const SizedBox(height: 20),

            // Utilisation de l'énumération pour vérifier les rôles
            if (_userRole == UserRole.visitor) _buildJoinLeaveButton(),
            const SizedBox(height: 20),

            if (_userRole == UserRole.admin) _buildAddMemberSection(),
            const SizedBox(height: 20),

            _buildMembersSection(),
            const SizedBox(height: 20),

            if (_userRole == UserRole.admin || _userRole == UserRole.member)
              _buildChatSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo(Map<String, dynamic> group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(group['name'] ?? ''),
        subtitle: Text(group['description'] ?? ''),
        trailing: Text('${group['membersCount']} membres'),
      ),
    );
  }

  Widget _buildJoinLeaveButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _toggleMembership,
        icon: Icon(
            _userRole == UserRole.member ? Icons.exit_to_app : Icons.group_add),
        label: Text(_userRole == UserRole.member
            ? 'Quitter le Groupe'
            : 'Rejoindre le Groupe'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _userRole == UserRole.member
              ? Colors.redAccent
              : const Color(0xFF1B3A57),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildAddMemberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajouter un membre :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _memberController,
                decoration: const InputDecoration(
                  hintText: 'Nom du membre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
              ),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    final roles = widget.group['roles'];
    final admins = roles['admin'];
    final members = roles['members'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Membres :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          color: const Color.fromARGB(235, 236, 236, 236),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            title: Text(
              '${members.length + admins.length} Membres',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            iconColor: const Color(0xFF1B3A57),
            children: [
              // Liste des admins
              ...admins.map((admin) => MemberCard(name: admin, isAdmin: true)),

              // Liste des membres avec suppression si l'utilisateur est admin
              ...members.map((member) => MemberCard(
                    name: member,
                    isAdmin: false,
                    onRemove: (_userRole == UserRole.admin)
                        ? () => _removeMember(member)
                        : null,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chat du Groupe :',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          height: 200, // Limiter la hauteur du chat
          decoration: BoxDecoration(
            color: const Color.fromARGB(235, 236, 236, 236),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Text(
                  message['sender']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(message['message']!),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Écrivez un message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _sendMessage, // Associer correctement la fonction ici
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
