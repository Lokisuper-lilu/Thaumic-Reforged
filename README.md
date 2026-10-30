# 神秘重铸 · Thaumic Reforged

Minecraft 1.12.2 / Thaumcraft 6 的独立 Forge 附属模组。第一阶段只提供开发环境、最小主类和只读 API 链接检查；没有注册物品、方块或其他游戏机制。

## 固定版本

| 组件 | 版本 |
| --- | --- |
| Mod ID / 版本 | `thaumicreforged` / `0.1.0` |
| Minecraft | `1.12.2` |
| Forge | `14.23.5.2860` |
| ForgeGradle | `3.0.197`（官方 2860 MDK 使用的 3.x 系列） |
| Gradle Wrapper | `4.9`（官方 MDK 原版 Wrapper，发行包校验 SHA-256） |
| JDK / 字节码 | Java 8 / class major version 52 |
| 本机 JDK | Eclipse Temurin `1.8.0_504-b01`，仅安装到 `.tools/jdk8` |
| MCP mappings | `snapshot_20171003-1.12`（MDK 默认） |
| Thaumcraft | `6.1.BETA26`，CurseForge 文件 `2629023` |
| Baubles | `1.5.2`，CurseForge 文件 `2518667` |

## Git 仓库与分支

- 主仓库（`origin`）：[Gitea / Thaumic-Reforged](https://gitea.6618661.xyz:5667/liuqi/Thaumic-Reforged)。
- 同步仓库（`github`）：[GitHub / Thaumic-Reforged](https://github.com/Lokisuper-lilu/Thaumic-Reforged)，SSH 地址 `git@github.com:Lokisuper-lilu/Thaumic-Reforged.git`。
- `main` 保存第一阶段基线；`devlop` 为开发分支，分支拼写沿用项目指定名称。

```bash
git clone https://gitea.6618661.xyz:5667/liuqi/Thaumic-Reforged.git 'Thaumic Reforged'
cd 'Thaumic Reforged'
git switch devlop
git remote add github git@github.com:Lokisuper-lilu/Thaumic-Reforged.git
```

JDK、依赖缓存、客户端数据和构建产物均被 Git 忽略；开发者按下方步骤下载依赖并构建。

## 构建（Linux / macOS）

需要 Git、完整 JDK 8 和可访问依赖仓库的网络。Linux x86_64 可使用提供的脚本安装项目专用 JDK；需要 `bash`、`curl`、`tar`、`sha256sum`：

```bash
cd '/path/to/Thaumic Reforged'
./scripts/bootstrap-jdk8.sh
./scripts/gradle.sh --version
./scripts/gradle.sh clean build --console=plain
```

已有 JDK 8 时，无须下载：

```bash
JAVA8_HOME=/absolute/path/to/jdk8 ./scripts/gradle.sh clean build
```

`scripts/gradle.sh` 按 `JAVA8_HOME`、`.tools/jdk8`、`JAVA_HOME` 的顺序选择 JDK，并拒绝 Java 8 之外的版本。脚本只更改当前子进程环境，不改系统 alternatives、全局 Java 或用户 Gradle 配置；默认 Gradle 缓存在项目的 `.gradle-user-home/`。

也可直接使用官方 Wrapper：

```bash
export JAVA_HOME=/absolute/path/to/jdk8
export PATH="$JAVA_HOME/bin:$PATH"
./gradlew clean build
```

Windows PowerShell（先安装适合 Windows 的 JDK 8）：

```powershell
$env:JAVA_HOME = 'C:\Java\jdk8'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
.\gradlew.bat --version
.\gradlew.bat clean build --console=plain
.\gradlew.bat runClient
```

产物：`build/libs/thaumicreforged-0.1.0.jar`。`jar` 后执行官方 `reobfJar` 流程。第三方依赖不合并、不嵌套到本模组 JAR。Windows / macOS 的实际构建尚未验证。

## 开发客户端

```bash
./scripts/gradle.sh runClient --console=plain
```

需要可用的图形显示、OpenGL 和本机音频库。首次启动会下载 Minecraft 资源与 LWJGL 本地库。开发运行目录为 `run/`，无需手工往 `run/mods` 重复复制 Thaumcraft / Baubles。

在主菜单打开 **Mods**，确认 Forge、Thaumcraft `6.1.BETA26`、Baubles `1.5.2` 和 Thaumic Reforged `0.1.0`。退出使用游戏的 Quit Game 按钮。日志位于 `run/logs/latest.log`、`run/logs/debug.log`；本模组应输出：

```text
Thaumic Reforged 0.1.0: pre-initialization
Public API linkage OK: Thaumcraft Aspect.AIR=aer, Baubles BaubleType.RING=RING
Thaumic Reforged 0.1.0: initialization complete (environment validation only)
```

主类只读取 `thaumcraft.api.aspects.Aspect.AIR.getTag()` 和 `baubles.api.BaubleType.RING.name()`。编译验证真实公开 API，启动日志验证运行时类与方法链接；不会注册或修改游戏内容。

## 依赖及来源

| 依赖 | Gradle 坐标 | 官方发布页 |
| --- | --- | --- |
| Forge | `net.minecraftforge:forge:1.12.2-14.23.5.2860` | [官方 1.12.2 下载页](https://files.minecraftforge.net/net/minecraftforge/forge/index_1.12.2.html) |
| Thaumcraft | `curse.maven:thaumcraft-223628:2629023` | [Azanor13 的 BETA26 发布文件](https://www.curseforge.com/minecraft/mc-mods/thaumcraft/files/2629023) |
| Baubles | `curse.maven:baubles-227083:2518667` | [Azanor13 的 1.5.2 发布文件](https://www.curseforge.com/minecraft/mc-mods/baubles/files/2518667) |

Thaumcraft / Baubles 通过 [CurseMaven](https://cursemaven.com/) 按固定项目 ID 与文件 ID 获取官方发布的二进制。`implementation fg.deobf(...)` 同时提供编译 classpath 和开发运行 classpath；`fg.deobf` 只在 Gradle 缓存生成适配 MCP 的副本，不修改原始模组。`implementation` 不会把依赖内容打入本项目 JAR。普通玩家运行时仍须独立安装 Forge 和这两个模组。

本项目不复制 Thaumcraft 完整源码或 API 源码，也不提供替代 API。依赖二进制、JDK、缓存和运行数据均由 Git 忽略。第三方模组保留其原作者许可，下载来源和校验值见 [docs/DEPENDENCIES.md](docs/DEPENDENCIES.md)。

Forge 1.12.2 使用 `@Mod` 和 `mcmod.info`，这里没有新版本 Forge 使用的 `mods.toml`。Minecraft 依赖通过 `acceptedMinecraftVersions="[1.12.2]"` 声明；Forge、Thaumcraft、Baubles 的必需版本和加载顺序在主类声明。

## 旧版工具链及网络兼容

1. **系统 Java 25 不兼容此工具链**：仅使用项目专用 JDK 8；不升级 ForgeGradle 主版本。
2. **TLS**：本机代理下 curl 默认握手出现 `unexpected eof while reading`，相同官方 URL 固定 TLS 1.2 后成功。下载脚本、Gradle JVM 和 Wrapper 启动脚本固定 TLS 1.2；保留 HTTPS 证书校验。
3. **代理**：Java / Gradle 不自动读取 `HTTPS_PROXY`。`scripts/gradle.sh` 将无认证 `http://host:port` 形式的 `HTTPS_PROXY` 转成当前进程 JVM 代理参数。其他代理可在当前 `GRADLE_USER_HOME/gradle.properties` 写入 `systemProp.https.proxyHost`、`systemProp.https.proxyPort` 等；不要提交凭据。直接使用 Wrapper 或 Windows 时须自行配置代理。
4. **历史仓库**：使用 Forge 官方 HTTPS Maven、Maven Central 和固定文件 ID 的 CurseMaven，不使用已停用的 JCenter/Bintray，不关闭必要构建步骤。
5. **可复现版本**：固定 ForgeGradle 补丁版和 Wrapper 发行包 SHA-256；不依赖本机全局 Gradle。
6. **CurseMaven 与 FG3 的映射顺序**：实测 CurseMaven 对 `_mapped_` 后缀仍返回原版 JAR。因此在 FG3 完成仓库注册后把 CurseMaven 移至最后，让 FG 的虚拟仓库优先生成映射副本。`verifyDevelopmentDependencies` 在编译前校验实际 classpath，拒绝原版 JAR 回退，防止只编译成功而运行时报缺失方法。
7. **首次重映射工具下载**：曾在并行重映射时观察到 `ZipException`；将 Gradle worker 限制为 1，并移走重映射工具和输出缓存后复验成功。没有修改 ForgeGradle 或第三方模组文件。
8. **Forge 的 `Side.BUKKIT` 崩溃**：使用官方 `mergetool:0.2.3.3:forge` helper，并在开发 JavaExec classpath 中优先加载，使运行时 `Side` 只有 CLIENT/SERVER。ASM 组件与 Forge 自带的 `asm-debug-all:5.2` 对齐，避免旧扫描器解析 ASM 6 的 Java 9 模块描述失败。
9. **Thaumcraft Access Transformer**：构建时校验原始 Thaumcraft SHA-256，并将其 JAR 内 `META-INF/tc_at.cfg` 原样提取到 `.gradle/thaumcraft/`，通过 FG3 应用到开发副本；解决 `BlockRailPowered.<init>` 等访问权限错误。该配置不进入交付 JAR。
10. **源码运行元数据与退出**：将处理后的资源输出到主类目录，满足旧 FML 在同一目录查找 `mcmod.info` 的要求；设置 `forceExit false`，避免游戏退出后 FG3 对 Gradle daemon 执行 `System.exit(0)`。这些都是构建/运行配置，不添加游戏功能。

完整原因、上游源码和验证边界见 [docs/COMPATIBILITY.md](docs/COMPATIBILITY.md)。

实际验证命令、通过情况及尚未验证项见 [docs/VALIDATION.md](docs/VALIDATION.md)。

## 可选：Minecraft Mod MCP

用户提供的 [minecraft-mod-mcp](https://github.com/langyo/minecraft-mod-mcp) 已核对并实测 Forge 1.12.2 专用 `v0.4.20`。需要自动化界面检查时运行：

```bash
./scripts/run-client-mcp.sh --console=plain
curl http://127.0.0.1:9876/api/status
```

脚本下载并校验官方 release JAR，临时放入被 Git 忽略的 `run/mods/`，结束时只删除本次脚本添加的文件。它不改变正常 `runClient` 的依赖，不修改 Codex 全局 MCP 配置，也不安装全局 npm 包。本次通过该模组提供的本地 HTTP API 验证，无须安装 stdio bridge。实际端口以启动日志和 `/api/status` 为准。

已验证按钮查询、按 ID 点击、截图文件输出与退出。旧版 Mods 列表的通用 `select_list_item` 返回不支持；在本机 Mesa 下截图/控制期间观察到 OpenGL 1282 日志，因此此工具保持可选。基础验收使用不带 MCP 的客户端，只有 7 个含 Forge 内置项的模组。详见 [验证记录](docs/VALIDATION.md)。

## 工程结构

```text
Thaumic Reforged/
├── build.gradle
├── settings.gradle
├── gradle.properties
├── gradlew / gradlew.bat
├── gradle/wrapper/                  # 官方 Wrapper JAR、属性与发行包 SHA-256
├── scripts/                        # 项目专用 JDK 与 Gradle 启动
├── src/main/java/io/github/thaumicreforged/ThaumicReforged.java
├── src/main/resources/{mcmod.info,pack.mcmeta}
├── docs/                           # 依赖来源、兼容性与实际验证记录
├── .gitignore / .gitattributes
├── README.md
├── .tools/                         # 忽略：JDK、下载、原始验证日志
├── .gradle-user-home/               # 忽略：项目 Gradle 缓存
├── build/                          # 忽略：编译产物
└── run/                            # 忽略：开发客户端数据与日志
```

随 MDK 附带的 `LICENSE*.txt`、`CREDITS.txt`、`changelog.txt`、`README.txt` 是上游工具链声明/说明，不代表本项目代码获得相同许可；当前未替项目新代码选择开源许可证。
