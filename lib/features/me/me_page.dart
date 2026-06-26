import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
import 'package:vynce_frontend/features/map/services/map_service.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final ProfileService _profileService = getIt<ProfileService>();
  final MapService _mapService = getIt<MapService>();
  ProfileModel? _profile;
  String? _location;
  bool _loadingLocation = false;
  File? _pickedBannerImage;
  File? _pickedAvatarImage;
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _selectedInterests = [
    {'label': 'Música', 'emoji': '🎵'},
    {'label': 'Festa', 'emoji': '🎉'},
  ];
  final List<Map<String, dynamic>> _allInterests = [
    {'label': 'Música', 'emoji': '🎵'},
    {'label': 'Festa', 'emoji': '🎉'},
    {'label': 'Open air', 'emoji': '🌿'},
    {'label': 'Teatro', 'emoji': '🎭'},
    {'label': 'Cinema', 'emoji': '🎬'},
    {'label': 'Esportes', 'emoji': '🌐'},
    {'label': 'Tech', 'emoji': '🖥️'},
  ];
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final result = await _profileService.getProfile('1');

    setState(() {
      _profile = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: _appBar(),
      body: Column(children: [_bodyHeader(), _body()]),
    );
  }

  Future<void> _pickImage({required bool isBanner}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (isBanner) {
        _pickedBannerImage = File(picked.path);
      } else {
        _pickedAvatarImage = File(picked.path);
      }
    });
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
            Row(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Text(
                  'Meu Perfil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: Text(
                'Salvar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyHeader() {
    return SizedBox(
      height: 220, // altura total da área (banner + avatar saindo por baixo)
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner com gradiente
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              image: _pickedBannerImage != null
                  ? DecorationImage(
                      image: FileImage(_pickedBannerImage!),
                      fit: BoxFit.cover,
                    )
                  : (_profile!.bannerUrl != null &&
                        _profile!.bannerUrl!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(_profile!.bannerUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF6A0DAD), // roxo escuro
                  Color(0xFFD63384), // pink
                ],
              ),
            ),
            // Overlay escuro sobre a imagem (só aplica se tiver imagem)
            child:
                (_profile!.bannerUrl != null && _profile!.bannerUrl!.isNotEmpty)
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Color(0xFFD63384).withOpacity(0.3),
                        ],
                      ),
                    ),
                  )
                : null,
          ),

          // Botão "Editar capa" — canto inferior direito do banner
          Positioned(
            bottom: 44, // acima do avatar
            right: 12,
            child: GestureDetector(
              onTap: () => _pickImage(isBanner: true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Editar capa",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Avatar circular saindo por baixo do banner
          Positioned(
            bottom: 0,
            left: 16,
            child: GestureDetector(
              onTap: () => _pickImage(isBanner: false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      // Avatar
                      Container(
                        width: 102,
                        height: 102,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: _pickedAvatarImage != null
                              ? Image.file(
                                  _pickedAvatarImage!,
                                  fit: BoxFit.cover,
                                  width: 72,
                                  height: 72,
                                )
                              : (_profile!.avatarUrl != null &&
                                    _profile!.avatarUrl!.isNotEmpty)
                              ? Image.network(
                                  _profile!.avatarUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  /* fallback com iniciais, igual já está */
                                ),
                        ),
                      ),

                      // Ícone de câmera sobre o avatar
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para iniciais
  String _getInitials() {
    final name = _profile?.name ?? "";
    final parts = name.trim().split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty)
      return parts[0][0].toUpperCase();
    return "?";
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          spacing: 16,
          children: [
            _basicDataCard(),
            _contactCard(),
            _interestsCard(),
            // _privacyCard(),
            _accountCard(),
          ],
        ),
      ),
    );
  }

  Widget _accountCard() {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            'CONTA',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
              fontSize: 12,
            ),
          ),

          // Sair da conta
          GestureDetector(
            onTap: () {
              // logout
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.35),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    size: 18,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sair da conta',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Excluir conta
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  title: Text(
                    'Excluir conta',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Tem certeza que deseja excluir sua conta? Essa ação é irreversível e todos os seus dados serão perdidos.',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // chamar delete account
                      },
                      child: Text(
                        'Excluir',
                        style: TextStyle(
                          color: Color(0xFF8B1A1A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFDF0F0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE8C0C0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Color(0xFF8B1A1A),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Excluir conta',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _basicDataCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'DADOS BÁSICOS',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            fontSize: 12,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    // borda padrão
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // sem foco
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // com foco
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    // erro
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // cor do label
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome de Usúario',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    // borda padrão
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // sem foco
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // com foco
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    // erro
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // cor do label
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),
                TextField(
                  maxLines: 5, // altura fixa com 5 linhas
                  minLines: 3, // altura mínima
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    // borda padrão
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // sem foco
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // com foco
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    // erro
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // cor do label
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: _loadingLocation ? null : () => _setLocation(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ), // 👈 área de toque maior
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (_loadingLocation)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Icon(
                            Icons.my_location,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.35),
                          ),
                        SizedBox(width: 8),
                        Text(
                          _location ?? 'Buscar Minha Localização',
                          style: TextStyle(
                            color: _location != null
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _interestsCard() {
    final selected = _allInterests
        .where((i) => _selectedInterests.any((s) => s['label'] == i['label']))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'INTERESSES',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            fontSize: 12,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 22),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // só os selecionados
              ...selected.map(
                (item) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['emoji'] as String),
                      SizedBox(width: 6),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // botão Outro
              GestureDetector(
                onTap: _showInterestsModal,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Outro',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInterestsModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escolha seus interesses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allInterests.map((item) {
                      final label = item['label'] as String;
                      final selected = _selectedInterests.any(
                        (s) => s['label'] == label,
                      );
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            if (selected) {
                              _selectedInterests.removeWhere(
                                (s) => s['label'] == label,
                              );
                            } else {
                              _selectedInterests.add({
                                'label': label,
                                'emoji': item['emoji'],
                              });
                            }
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.35),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item['emoji'] as String),
                              SizedBox(width: 6),
                              Text(
                                label,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Confirmar'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _privacyCard() {
    final items = [
      {'title': 'Perfil público', 'subtitle': 'Qualquer pessoa pode ver'},
      {'title': 'Mostrar localização', 'subtitle': 'Apenas seguidores'},
      {'title': 'Notificações', 'subtitle': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'PRIVACIDADE',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // navegar para a configuração
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                              if (item['subtitle'] != null) ...[
                                SizedBox(height: 2),
                                Text(
                                  item['subtitle'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.35),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _contactCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'CONTATO',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            fontSize: 12,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    // borda padrão
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // sem foco
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // com foco
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    // erro
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // cor do label
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Celular',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    // borda padrão
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // sem foco
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.35),
                      ),
                    ),
                    // com foco
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    // erro
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    // cor do label
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _setLocation() async {
    setState(() => _loadingLocation = true);

    try {
      final latlng = await _mapService.getCurrentLocation();
      final locationRes = await _mapService.reverseGeocode(latlng);
      setState(() => _location = locationRes);
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loadingLocation = false);
    }
  }
}
