package io.github.thaumicreforged;

import baubles.api.BaubleType;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.event.FMLInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPostInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPreInitializationEvent;
import org.apache.logging.log4j.Logger;
import thaumcraft.api.aspects.Aspect;

/** Phase one: lifecycle logging and read-only public API linkage checks. */
@Mod(
        modid = ThaumicReforged.MOD_ID,
        name = ThaumicReforged.MOD_NAME,
        version = ThaumicReforged.VERSION,
        acceptedMinecraftVersions = "[1.12.2]",
        dependencies = "required-after:forge@[14.23.5.2860,14.24);"
                + "required-after:thaumcraft@[6.1.BETA26];"
                + "required-after:baubles@[1.5.2]"
)
public final class ThaumicReforged {
    public static final String MOD_ID = "thaumicreforged";
    public static final String MOD_NAME = "Thaumic Reforged";
    public static final String VERSION = "0.1.0";

    private Logger logger;

    @Mod.EventHandler
    public void preInit(FMLPreInitializationEvent event) {
        logger = event.getModLog();
        logger.info("{} {}: pre-initialization", MOD_NAME, VERSION);
    }

    @Mod.EventHandler
    public void init(FMLInitializationEvent event) {
        // Resolve existing API values only; do not register or change game data.
        logger.info("Public API linkage OK: Thaumcraft Aspect.AIR={}, Baubles BaubleType.RING={}",
                Aspect.AIR.getTag(), BaubleType.RING.name());
    }

    @Mod.EventHandler
    public void postInit(FMLPostInitializationEvent event) {
        logger.info("{} {}: initialization complete (environment validation only)", MOD_NAME, VERSION);
    }
}
