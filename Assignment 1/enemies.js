// enemies.js – enemy data and generator (uses arrays and filter)
const enemyLibrary = [
    { name: "🕷️ Giant Spider",   minLevel: 1, health: 18, attack: 7,  gold: 12, xp: 18, battleCry: "Chittering mandibles!" },
    { name: "🧟 Skeleton Guard", minLevel: 1, health: 22, attack: 8,  gold: 15, xp: 22, battleCry: "Rattle... bone!" },
    { name: "🐺 Shadow Wolf",     minLevel: 2, health: 26, attack: 11, gold: 20, xp: 28, battleCry: "Howl in the dark!" },
    { name: "🔥 Fire Imp",        minLevel: 2, health: 20, attack: 13, gold: 18, xp: 25, battleCry: "Burn, mortal!" },
    { name: "🪦 Dark Cultist",    minLevel: 3, health: 32, attack: 14, gold: 25, xp: 35, battleCry: "For the Old One!" },
    { name: "🗿 Stone Golem",     minLevel: 3, health: 48, attack: 12, gold: 32, xp: 42, battleCry: "Crush... puny flesh." },
    { name: "👑 Lich Remnant",    minLevel: 4, health: 44, attack: 18, gold: 45, xp: 58, battleCry: "Your soul is forfeit!" },
    { name: "🐉 Young Wyrm",      minLevel: 4, health: 56, attack: 20, gold: 60, xp: 75, battleCry: "Roar echoes!" }
];

// Filter enemies based on player level (array .filter method)
export function getRandomEnemy(playerLevel) {
    const possible = enemyLibrary.filter(enemy => enemy.minLevel <= playerLevel);
    if (possible.length === 0) return null;
    const randomIndex = Math.floor(Math.random() * possible.length);
    // Return a copy to avoid mutation
    return { ...possible[randomIndex] };
}

// Optional: get enemy by name (for completeness)
export function getAllEnemies() {
    return [...enemyLibrary];
}
