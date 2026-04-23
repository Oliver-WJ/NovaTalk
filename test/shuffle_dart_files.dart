import 'dart:io';
import 'dart:math';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('用法: dart shuffle_dart_files.dart <目录路径>');
    exit(1);
  }

  final directoryPath = arguments[0];
  final directory = Directory(directoryPath);

  if (!await directory.exists()) {
    print('错误: 目录不存在: $directoryPath');
    exit(1);
  }

  await processDirectory(directory);
  print('完成！');
}

Future<void> processDirectory(Directory directory) async {
  await for (final entity in directory.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      print('处理文件: ${entity.path}');
      await processFile(entity);
    }
  }
}

Future<void> processFile(File file) async {
  try {
    final content = await file.readAsString();
    final fixedContent = fixCommonSyntaxErrors(content);
    final shuffledContent = shuffleDartFile(fixedContent);
    await file.writeAsString(shuffledContent);
    print('✓ 已处理: ${file.path}');
  } catch (e) {
    print('✗ 处理失败: ${file.path}, 错误: $e');
    print('堆栈: $e');
  }
}

String fixCommonSyntaxErrors(String content) {
  // 修复缺少类型前缀的枚举值错误
  // 匹配模式：属性名: .枚举值
  // 例如：crossAxisAlignment: .start -> crossAxisAlignment: CrossAxisAlignment.start

  final pattern = RegExp(r'(\w+):\s*\.(\w+)');

  return content.replaceAllMapped(pattern, (match) {
    final propertyName = match.group(1)!;
    final enumValue = match.group(2)!;

    // 将 camelCase 属性名转换为 PascalCase 类型名
    final typeName = _camelToPascal(propertyName);

    return '$propertyName: $typeName.$enumValue';
  });
}

String _camelToPascal(String camelCase) {
  if (camelCase.isEmpty) return camelCase;
  // 将首字母大写
  return camelCase[0].toUpperCase() + camelCase.substring(1);
}

String shuffleDartFile(String content) {
  final parseResult = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
  );

  if (parseResult.errors.isNotEmpty) {
    print('解析错误:');
    for (final error in parseResult.errors) {
      print('  - ${error.message}');
    }
  }

  final unit = parseResult.unit;
  final visitor = DartFileShuffler(content);

  // 只访问顶层声明，不深入访问
  for (final declaration in unit.declarations) {
    declaration.accept(visitor);
  }

  return visitor.generateShuffledContent(content, unit);
}

class DartFileShuffler extends SimpleAstVisitor<void> {
  final String sourceContent;
  final List<ClassInfo> classes = [];
  final List<TopLevelInfo> topLevelItems = [];

  DartFileShuffler(this.sourceContent);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final members = _extractClassMembers(node);

    classes.add(ClassInfo(
      offset: node.offset,
      end: node.end,
      name: node.name.lexeme,
      leftBracket: node.leftBracket.offset,
      rightBracket: node.rightBracket.offset,
      members: members,
      node: node,
    ));

    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: true,
      classInfo: classes.last,
    ));

    // 不再调用 super，避免深入访问类成员
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: false,
      content: node.toSource(),
    ));
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    final members = _extractMixinMembers(node);

    classes.add(ClassInfo(
      offset: node.offset,
      end: node.end,
      name: node.name.lexeme,
      leftBracket: node.leftBracket.offset,
      rightBracket: node.rightBracket.offset,
      members: members,
      node: null,
      isMixin: true,
    ));

    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: true,
      classInfo: classes.last,
    ));
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: false,
      content: node.toSource(),
    ));
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: false,
      content: node.toSource(),
    ));
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: false,
      content: node.toSource(),
    ));
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: false,
      content: node.toSource(),
    ));
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    topLevelItems.add(TopLevelInfo(
      offset: node.offset,
      end: node.end,
      isClass: false,
      content: node.toSource(),
    ));
  }

  List<MemberInfo> _extractClassMembers(ClassDeclaration node) {
    final members = <MemberInfo>[];

    // 只遍历直接成员，不深入访问
    for (final member in node.members) {
      final isStatic = _isStaticMember(member);
      final memberType = _getMemberType(member);

      members.add(MemberInfo(
        offset: member.offset,
        end: member.end,
        content: member.toSource(),
        isStatic: isStatic,
        type: memberType,
      ));
    }

    return members;
  }

  List<MemberInfo> _extractMixinMembers(MixinDeclaration node) {
    final members = <MemberInfo>[];

    // 只遍历直接成员，不深入访问
    for (final member in node.members) {
      final isStatic = _isStaticMember(member);
      final memberType = _getMemberType(member);

      members.add(MemberInfo(
        offset: member.offset,
        end: member.end,
        content: member.toSource(),
        isStatic: isStatic,
        type: memberType,
      ));
    }

    return members;
  }

  bool _isStaticMember(ClassMember member) {
    if (member is MethodDeclaration) {
      return member.isStatic;
    } else if (member is FieldDeclaration) {
      return member.isStatic;
    }
    return false;
  }

  MemberType _getMemberType(ClassMember member) {
    if (member is ConstructorDeclaration) {
      return MemberType.constructor;
    } else if (member is MethodDeclaration) {
      return MemberType.method;
    } else if (member is FieldDeclaration) {
      return MemberType.field;
    }
    return MemberType.other;
  }

  String generateShuffledContent(String originalContent, CompilationUnit unit) {
    final imports = <String>[];
    final exports = <String>[];
    final parts = <String>[];
    final partOfs = <String>[];

    // 提取 imports、exports 和 part 声明
    for (final directive in unit.directives) {
      if (directive is ImportDirective) {
        imports.add(directive.toSource());
      } else if (directive is ExportDirective) {
        exports.add(directive.toSource());
      } else if (directive is PartDirective) {
        parts.add(directive.toSource());
      } else if (directive is PartOfDirective) {
        partOfs.add(directive.toSource());
      }
    }

    // 获取文件开头的注释和空白
    String prefix = '';
    if (unit.directives.isNotEmpty) {
      prefix = originalContent.substring(0, unit.directives.first.offset);
    } else if (topLevelItems.isNotEmpty) {
      prefix = originalContent.substring(0, topLevelItems.first.offset);
    }

    final buffer = StringBuffer();

    // 添加前缀（注释等）
    if (prefix.trim().isNotEmpty) {
      buffer.writeln(prefix.trimRight());
    }

    // 添加 part of（如果存在）
    if (partOfs.isNotEmpty) {
      buffer.writeln(partOfs.join('\n'));
      buffer.writeln();
    }

    // 添加 imports
    if (imports.isNotEmpty) {
      buffer.writeln(imports.join('\n'));
      buffer.writeln();
    }

    // 添加 exports
    if (exports.isNotEmpty) {
      buffer.writeln(exports.join('\n'));
      buffer.writeln();
    }

    // 添加 parts
    if (parts.isNotEmpty) {
      buffer.writeln(parts.join('\n'));
      buffer.writeln();
    }

    // 随机打乱顶层元素（类、函数、typedef等）
    final shuffledTopLevel = List<TopLevelInfo>.from(topLevelItems);
    shuffledTopLevel.shuffle(Random());

    for (int i = 0; i < shuffledTopLevel.length; i++) {
      final item = shuffledTopLevel[i];

      if (item.isClass && item.classInfo != null) {
        buffer.write(_generateShuffledClass(item.classInfo!));
      } else {
        buffer.write(item.content);
      }

      if (i < shuffledTopLevel.length - 1) {
        buffer.writeln();
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  String _generateShuffledClass(ClassInfo classInfo) {
    final buffer = StringBuffer();

    // 提取类头部（从开始到左大括号）
    final header = sourceContent.substring(
      classInfo.offset,
      classInfo.leftBracket + 1, // 包含左大括号
    );

    buffer.write(header);

    // 如果类有成员，添加换行
    if (classInfo.members.isNotEmpty) {
      buffer.writeln();
    }

    // 分组：构造函数、静态字段、静态方法、实例字段、实例方法
    final constructors = classInfo.members
        .where((m) => m.type == MemberType.constructor)
        .toList();

    final staticFields = classInfo.members
        .where((m) => m.isStatic && m.type == MemberType.field)
        .toList();

    final staticMethods = classInfo.members
        .where((m) => m.isStatic && m.type == MemberType.method)
        .toList();

    final instanceFields = classInfo.members
        .where((m) => !m.isStatic && m.type == MemberType.field)
        .toList();

    final instanceMethods = classInfo.members
        .where((m) => !m.isStatic && m.type == MemberType.method)
        .toList();

    final others = classInfo.members
        .where((m) => m.type == MemberType.other)
        .toList();

    // 打乱各组（但保持构造函数的相对顺序）
    staticFields.shuffle(Random());
    staticMethods.shuffle(Random());
    instanceFields.shuffle(Random());
    instanceMethods.shuffle(Random());

    // 按顺序输出：构造函数 -> 静态字段 -> 静态方法 -> 实例字段 -> 实例方法 -> 其他
    final orderedMembers = [
      ...constructors,
      ...staticFields,
      ...staticMethods,
      ...instanceFields,
      ...instanceMethods,
      ...others,
    ];

    // 输出成员
    for (int i = 0; i < orderedMembers.length; i++) {
      final member = orderedMembers[i];

      // 添加适当的缩进
      final lines = member.content.split('\n');
      for (int j = 0; j < lines.length; j++) {
        final line = lines[j];
        if (line.trim().isNotEmpty || j < lines.length - 1) {
          buffer.write('  ');
          buffer.write(line);
          buffer.writeln();
        }
      }

      // 在成员之间添加空行
      if (i < orderedMembers.length - 1) {
        buffer.writeln();
      }
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}

enum MemberType {
  constructor,
  field,
  method,
  other,
}

class ClassInfo {
  final int offset;
  final int end;
  final String name;
  final int leftBracket;
  final int rightBracket;
  final List<MemberInfo> members;
  final ClassDeclaration? node;
  final bool isMixin;

  ClassInfo({
    required this.offset,
    required this.end,
    required this.name,
    required this.leftBracket,
    required this.rightBracket,
    required this.members,
    this.node,
    this.isMixin = false,
  });
}

class MemberInfo {
  final int offset;
  final int end;
  final String content;
  final bool isStatic;
  final MemberType type;

  MemberInfo({
    required this.offset,
    required this.end,
    required this.content,
    this.isStatic = false,
    required this.type,
  });
}

class TopLevelInfo {
  final int offset;
  final int end;
  final bool isClass;
  final ClassInfo? classInfo;
  final String? content;

  TopLevelInfo({
    required this.offset,
    required this.end,
    required this.isClass,
    this.classInfo,
    this.content,
  });
}