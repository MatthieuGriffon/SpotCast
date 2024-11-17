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
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

 void _checkUserRole() {
  final roles = widget.group['roles'];
  final normalizedUserEmail = widget.currentUser.trim().toLowerCase();

  // Vérifie si l'utilisateur est un admin
  if (roles['admin'].any((admin) => admin.trim().toLowerCase() == normalizedUserEmail)) {
    setState(() => _userRole = UserRole.admin);
  } 
  // Vérifie si l'utilisateur est un membre
  else if (roles['members'].any((member) => member.trim().toLowerCase() == normalizedUserEmail)) {
    setState(() => _userRole = UserRole.member);
  } 
  // Sinon, c'est un visiteur
  else {
    setState(() => _userRole = UserRole.visitor);
  }
}

  // Ajouter un nouveau membre
  void _addMemberByEmail() {
    final newMemberEmail = _memberController.text.trim().toLowerCase();

    // Vérifier si l'email est valide et non vide
    if (newMemberEmail.isNotEmpty && newMemberEmail.contains('@')) {
      if (!widget.group['roles']['members'].contains(newMemberEmail)) {
        setState(() {
          widget.group['roles']['members'].add(newMemberEmail);
        });
        _memberController.clear();
        FocusScope.of(context).unfocus(); // Fermer le clavier
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membre ajouté avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cet utilisateur existe déjà !')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un email valide')),
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

  // Fonction pour envoyer un message
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

      // Fermer le clavier après l'envoi du message
      FocusScope.of(context).unfocus();

      // Faire défiler vers le bas après l'envoi du message
      _scrollToBottom();
    }
  }

  // Fonction pour faire défiler vers le bas
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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

            // Afficher le bouton pour rejoindre/quitter le groupe si l'utilisateur est un visiteur
            if (_userRole == UserRole.visitor) _buildJoinLeaveButton(),
            const SizedBox(height: 20),

            // Afficher la section d'ajout de membre si l'utilisateur est admin
            if (_userRole == UserRole.admin) _buildAddMemberSection(),
            const SizedBox(height: 20),

            // Afficher les membres et le chat si l'utilisateur est admin ou membre
            if (_userRole == UserRole.admin ||
                _userRole == UserRole.member) ...[
              _buildMembersSection(),
              _buildChatSection(),
              const SizedBox(height: 20),
            ],
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
          'Ajouter un membre par email :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _memberController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email du membre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addMemberByEmail,
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
        const Text(
          'Chat du Groupe :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 200, // Limiter la hauteur du chat
          decoration: BoxDecoration(
            color: const Color.fromARGB(235, 236, 236, 236),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            controller: _scrollController,
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
              onPressed: _sendMessage,
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
