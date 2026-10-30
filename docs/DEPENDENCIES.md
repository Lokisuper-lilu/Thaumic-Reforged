# 第三方依赖来源与固定版本

所有依赖均为独立下载/缓存的开发依赖，不将第三方源码或 JAR 内容复制、合并进本项目源码与交付 JAR。校验记录日期：2026-10-30（Asia/Shanghai）。

## 官方 Forge MDK 与构建工具

- 官方 MDK：[forge-1.12.2-14.23.5.2860-mdk.zip](https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2860/forge-1.12.2-14.23.5.2860-mdk.zip)
- MDK SHA-256：`d0de63c4109becaacff68308720ff99edb2534877853d3e34165c04341826461`
- MDK SHA-1：`76570ae728d487f23ce16d514e1202201b7501a3`，已与[官方 Maven 校验文件](https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2860/forge-1.12.2-14.23.5.2860-mdk.zip.sha1)比对。
- 官方 MDK 原版 `gradlew`、`gradlew.bat`、`gradle-wrapper.jar` 保留。原 `gradle-wrapper.properties` 仍指向 Gradle 4.9，只添加发行包 SHA-256。
- [Gradle 4.9 发行包](https://services.gradle.org/distributions/gradle-4.9-bin.zip) SHA-256：`e66e69dce8173dd2004b39ba93586a184628bc6c28461bc771d6835f7f9b0d28`，来自[Gradle 官方校验文件](https://services.gradle.org/distributions/gradle-4.9-bin.zip.sha256)。
- ForgeGradle 固定 `net.minecraftforge.gradle:ForgeGradle:3.0.197`，从 [Forge Maven](https://maven.minecraftforge.net/net/minecraftforge/gradle/ForgeGradle/3.0.197/ForgeGradle-3.0.197.pom) 获取，保持原 MDK `3.+` 的主版本。

## 项目专用 JDK 8（Linux x86_64）

- Eclipse Temurin `8u504-b01` / HotSpot；[Adoptium 官方发布](https://github.com/adoptium/temurin8-binaries/releases/tag/jdk8u504-b01)。
- 文件：`OpenJDK8U-jdk_x64_linux_hotspot_8u504b01.tar.gz`。
- SHA-256：`9c70e102f527ac674ac2fe9c7d47b9a04e2d19842ba5ab8e9b33f368bbadfaea`。
- 来源：[Adoptium API 元数据](https://api.adoptium.net/v3/assets/latest/8/hotspot?architecture=x64&image_type=jdk&os=linux&vendor=eclipse) 和[固定发行文件校验](https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u504-b01/OpenJDK8U-jdk_x64_linux_hotspot_8u504b01.tar.gz.sha256.txt)。安装脚本固定下载地址和校验值，不随 latest 漂移。
- 安装目录 `.tools/jdk8/`，只供当前项目使用；不改变系统默认 Java。

## Thaumcraft 6.1.BETA26

- 作者官方发布页：[项目 223628，文件 2629023](https://www.curseforge.com/minecraft/mc-mods/thaumcraft/files/2629023)。发布页包含 BETA26 hotfix1，此文件即本项目固定依赖。
- 原文件名：`Thaumcraft-1.12.2-6.1.BETA26.jar`。
- 官方 CDN：[edge.forgecdn.net 文件](https://edge.forgecdn.net/files/2629/23/Thaumcraft-1.12.2-6.1.BETA26.jar)。
- Maven：`curse.maven:thaumcraft-223628:2629023`，仓库 `https://cursemaven.com`。
- SHA-256：`9425f8643581b27ff8845b087c8bc6fc10425a32942f1a3f0e265ce6b38f7b5f`。
- 已实际下载官方 CDN 和 CurseMaven 两份原件，比对 SHA-256 完全一致。原件的 `@Mod` 注解版本为 `6.1.BETA26`，要求 Forge `>=14.23.5.2768`、Baubles `>=1.5.2`，Minecraft `[1.12.2]`。
- 原件 `mcmod.info` 的显示版本是 `1.12.2-6.1.BETA26`，依赖约束使用 Forge 实际识别的 `@Mod` 版本 `6.1.BETA26`。

## Baubles 1.5.2

- 作者官方发布页：[项目 227083，文件 2518667](https://www.curseforge.com/minecraft/mc-mods/baubles/files/2518667)。
- 原文件名：`Baubles-1.12-1.5.2.jar`，发布页明确支持 Minecraft 1.12.2。
- 官方 CDN：[edge.forgecdn.net 文件](https://edge.forgecdn.net/files/2518/667/Baubles-1.12-1.5.2.jar)。
- Maven：`curse.maven:baubles-227083:2518667`，仓库 `https://cursemaven.com`。
- SHA-256：`b32010b2f2778aa1188585e7ead91ad46d4cb2c715f9c778a61848ba7fe51f8d`。
- 已实际比对官方 CDN 和 CurseMaven 两份原件的 SHA-256。原件 `@Mod` 版本为 `1.5.2`，符合 BETA26 的最低要求。

## 编译与运行的区别

另有开发工具链兼容依赖 `net.minecraftforge:mergetool:0.2.3.3:forge`（官方 Forge Maven，实测 SHA-256 `00a1240cd4bc096290d51ed75c7080ed772fdd29f620a91887f50659556a98f2`），以及与 Forge 对齐的 ASM 5.2 组件。MergeTool helper 只影响开发 classpath，不进入交付 JAR；原因见 [COMPATIBILITY.md](COMPATIBILITY.md)。

```groovy
implementation fg.deobf('curse.maven:thaumcraft-223628:2629023')
implementation fg.deobf('curse.maven:baubles-227083:2518667')
```

本阶段二者都是必需依赖，因此同时加入编译和开发运行 classpath，而不是只用 `compileOnly`。ForgeGradle 将发行 JAR 中的 SRG 名称映射到本工程 MCP 名称，生成的副本位于缓存；原始模组文件不变。标准 Gradle `jar` 任务只收集本项目输出；没有 Shadow/Jar-in-Jar 配置。

注意 Gradle 4.9 不支持仓库 `content` 过滤。实测 CurseMaven 对 `_mapped_snapshot_20171003-1.12` 路径也返回未经转换的原版 JAR。`build.gradle` 在 FG3 的仓库注册完成后将 CurseMaven 放到最后，优先使用 FG3 合成仓库。编译前的 `verifyDevelopmentDependencies` 检查两个已映射依赖确实存在，且 SHA-256 与上述原版不同；若 FG3 转换异常后尝试回退到原版，构建会明确失败。

本次实测的开发映射副本（仅缓存，不交付）：Thaumcraft SHA-256 `533081a17aebc6ef2740884cd50745678736063b02bc8670eecccc505658d8b9`；Baubles SHA-256 `a4fc69e34229f8b89cc76b82d6e162c33cf50a314e7df581a703cfa7b56de0f2`。这两个值记录本次结果，不用作跨机器构建的固定二进制哈希要求。

玩家安装时分别提供 Forge 2860、Thaumcraft BETA26、Baubles 1.5.2 及本模组 JAR。运行期强制依赖由主类的 `required-after` 声明，并在 `mcmod.info` 记录。不要把原版模组和 Gradle 重映射副本同时放入 `run/mods`。

若 CurseMaven 未来不可访问，先按上述官方发布页和 CDN 下载，再比对 SHA-256；勿换用不明整合包或假 API。当前交付已验证的构建路径为 CurseMaven，未配置其他自动回退仓库。
