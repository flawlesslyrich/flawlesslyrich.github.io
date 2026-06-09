// combat.js – handles turn-based combat (loops, functions, arrow helpers)
import player from './player.js';

// Helper: attack damage formula (arrow function)
const calculateDamage = (attackerAttack, defenderDefense = 2) => {
    const base = Math.max(2, attackerAttack - Math.floor(defenderDefense / 2));
    return Math.floor(base + Math.random() * 8);
};

// Combat loop (uses while, return values win/flee/defeat)
export function startCombat(playerInstance, enemy) {
    let enemyCurrentHealth = enemy.health;
    const enemyAttackVal = enemy.attack;
    
    while (true) {
        // PLAYER TURN
        const action = prompt(
            `⚔️ COMBAT MENU ⚔️\n[${enemy.name}] HP: ${enemyCurrentHealth}/${enemy.health}\n❤️ Your HP: ${playerInstance.getHealth()}/${playerInstance.getMaxHealth()}\n\n1) ⚡ Attack\n2) 🏃 Flee (chance based on speed)\n3) 🍾 Use Health Potion`
        );
        
        if (action === null) {
            // Cancel = flee attempt with penalty
            const fleeRoll = Math.random();
            if (fleeRoll < 0.5) {
                alert("You failed to flee! Enemy strikes!");
                const dmg = calculateDamage(enemyAttackVal);
                const newHp = playerInstance.takeDamage(dmg);
                alert(`💥 ${enemy.name} hits you for ${dmg} damage! (HP: ${newHp}/${playerInstance.getMaxHealth()})`);
                if (newHp <= 0) return "defeat";
                continue;
            } else {
                alert("You successfully escape the fight!");
                return "flee";
            }
        }
        
        switch (action.trim()) {
            case "1": // Attack
                const playerDmg = calculateDamage(playerInstance.getAttack());
                enemyCurrentHealth -= playerDmg;
                alert(`⚡ You strike the ${enemy.name} for ${playerDmg} damage! Enemy HP: ${Math.max(0, enemyCurrentHealth)}`);
                if (enemyCurrentHealth <= 0) {
                    alert(`💀 ${enemy.name} falls! Victory is yours.`);
                    return "win";
                }
                break;
                
            case "2": // Flee
                const fleeSuccess = Math.random() < 0.55; // 55% base chance
                if (fleeSuccess) {
                    alert("You dash away and escape!");
                    return "flee";
                } else {
                    alert("Flee failed! The enemy attacks!");
                    const dmg = calculateDamage(enemyAttackVal);
                    const newHp = playerInstance.takeDamage(dmg);
                    alert(`💥 ${enemy.name} deals ${dmg} damage! (HP: ${newHp}/${playerInstance.getMaxHealth()})`);
                    if (newHp <= 0) return "defeat";
                }
                break;
                
            case "3": // Use Health Potion
                const inventory = playerInstance.getInventory();
                const potionIndex = inventory.findIndex(item => item.includes("Health Potion"));
                if (potionIndex === -1) {
                    alert("❌ No Health Potion in inventory! Find them by exploring.");
                    // Re-prompt without enemy turn
                    continue;
                }
                // Remove potion (array splice)
                playerInstance.removeItem(potionIndex);
                const healAmount = Math.floor(Math.random() * 18) + 12; // 12-29 HP
                const oldHp = playerInstance.getHealth();
                const newHpAfter = playerInstance.heal(healAmount);
                alert(`🍾 You drink a Health Potion! Restored ${newHpAfter - oldHp} HP. Now at ${newHpAfter}/${playerInstance.getMaxHealth()}`);
                break;
                
            default:
                alert("Invalid combat choice! Use 1, 2, or 3.");
                continue; // skip enemy turn
        }
        
        // ENEMY TURN (only if player attacked or used item and enemy still alive)
        if (enemyCurrentHealth > 0) {
            const enemyDmg = calculateDamage(enemyAttackVal);
            const newHp = playerInstance.takeDamage(enemyDmg);
            alert(`💢 ${enemy.name} attacks you for ${enemyDmg} damage! Your HP: ${newHp}/${playerInstance.getMaxHealth()}`);
            if (newHp <= 0) {
                alert(`💀 You have been slain by the ${enemy.name}... darkness consumes you.`);
                return "defeat";
            }
        }
    }
}
