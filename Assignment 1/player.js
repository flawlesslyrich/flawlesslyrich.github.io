// player.js – manages player state, inventory, leveling (closure pattern)
const createPlayer = () => {
    // Private variables (closure)
    let health = 42;
    let maxHealth = 42;
    let attack = 12;
    let level = 1;
    let gold = 25;
    let xp = 0;
    let inventory = ["⚔️ Rusty Dagger"];   // starting item (array)

    const xpNeededForNextLevel = () => Math.floor(40 + (level - 1) * 15);

    // Helper: level up (modifies stats)
    const applyLevelUp = () => {
        level++;
        maxHealth = Math.floor(maxHealth + 8 + Math.random() * 5);
        attack = Math.floor(attack + 3 + Math.random() * 3);
        health = maxHealth;  // full heal on level up
    };

    // Public interface (revealing module pattern)
    return {
        // Stats getters (arrow functions)
        getStats: () => ({ health, maxHealth, attack, level, gold, xp, xpToNext: xpNeededForNextLevel() }),
        getHealth: () => health,
        getMaxHealth: () => maxHealth,
        getAttack: () => attack,
        getLevel: () => level,
        getGold: () => gold,
        getXP: () => xp,
        
        // Inventory (array methods demonstration)
        getInventory: () => [...inventory],   // return copy (iteration elsewhere)
        addItem: (item) => {
            inventory.push(item);   // array push
            return true;
        },
        removeItem: (index) => {
            if (index >= 0 && index < inventory.length) {
                const removed = inventory.splice(index, 1); // array splice
                return removed[0];
            }
            return null;
        },
        
        // Modify resources
        addGold: (amount) => { gold += amount; return gold; },
        spendGold: (amount) => {
            if (gold >= amount) {
                gold -= amount;
                return true;
            }
            return false;
        },
        heal: (amount) => {
            health = Math.min(maxHealth, health + amount);
            return health;
        },
        takeDamage: (damage) => {
            health = Math.max(0, health - damage);
            return health;
        },
        addXP: (amount) => {
            xp += amount;
            let required = xpNeededForNextLevel();
            let leveled = false;
            while (xp >= required && level < 10) {   // max level 10
                xp -= required;
                applyLevelUp();
                required = xpNeededForNextLevel();
                leveled = true;
            }
            return leveled;  // true if at least one level up occurred
        },
        
        // Full reset (used on death)
        reset: () => {
            health = 42;
            maxHealth = 42;
            attack = 12;
            level = 1;
            gold = 25;
            xp = 0;
            inventory = ["⚔️ Rusty Dagger"];
        }
    };
};

const player = createPlayer();
export default player;